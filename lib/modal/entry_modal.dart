import 'dart:convert';

import 'package:expensenoted/constant.dart';
import 'package:expensenoted/interceptor.dart';
import 'package:expensenoted/modal/category_modal.dart';
import 'package:expensenoted/modal/entry_chart.dart';
import 'package:googleapis/tagmanager/v2.dart';
import 'package:http_interceptor/http_interceptor.dart';

enum Worthiness { worth, average, notWorth, necessity }

enum EntryAction {
  createNew,
  editExisting,
  viewDetail,
}

class Entry {
  final String id;
  List<EntryCategory> categories;
  String text;
  Worthiness worthiness;
  DateTime date;

  Entry({
    required this.id,
    required this.categories,
    required this.text,
    required this.worthiness,
    required this.date,
  });

  final httpI = InterceptedHttp.build(interceptors: [
    LoggingInterceptor(),
  ]);

  factory Entry.fromJson(Map<String, dynamic> json) {
    List<EntryCategory> categoryList;
    categoryList = (json['categories'] as List)
        .map((e) => EntryCategory.fromJson(e))
        .toList();

    final split =
        json['text'].toString().replaceAll(',', '\n').replaceAll('#', ' ');
    return Entry(
      id: json['_id'],
      categories: categoryList,
      text: split,
      worthiness: Worthiness.values.elementAt(json['worthiness']),
      date: DateTime.parse(json['date']),
    );
  }

  Future createEntry(Entry entry) async {
    entry.text = cleanText(entry.text);

    Uri uri = Uri.parse('$domain/entries');
    final userCat =
        entry.categories.where((element) => element.selected == true).toList();

    final body = jsonEncode({
      "categories": userCat,
      "text": entry.text,
      "worthiness": entry.worthiness.index,
      "date": entry.date.toIso8601String(),
    });

    try {
      await httpI
          .post(
        uri,
        headers: header,
        body: body,
      )
          .then((value) {
        if (value.statusCode == 200) {
          return true;
        }
      });
    } catch (err) {
      throw Exception(err);
    }
  }

  Future updateEntry(Entry entry) async {
    entry.text = cleanText(entry.text);

    Uri uri = Uri.parse('$domain/entries');
    final userCat = entry.categories
        .where(
          ((element) => element.selected == true),
        )
        .toList();
    final body = jsonEncode({
      "_id": entry.id,
      "categories": userCat,
      "text": entry.text,
      "worthiness": entry.worthiness.index,
      "date": entry.date.toIso8601String(),
    });
    try {
      await httpI
          .patch(
        uri,
        headers: header,
        body: body,
      )
          .then((value) {
        if (value.statusCode == 200) {
          return true;
        }
      });
    } catch (err) {
      throw Exception(err);
    }
  }

  Future deleteEntry(Entry entry) async {
    Uri uri = Uri.parse('$domain/entries');
    final body = jsonEncode({
      "_id": entry.id,
    });
    try {
      await httpI
          .delete(
        uri,
        headers: header,
        body: body,
      )
          .then((value) {
        if (value.statusCode == 200) {
          return true;
        }
      });
    } catch (err) {
      throw Exception(err);
    }
  }

  String cleanText(String text) {
    final split = text.split("\n");
    split.removeWhere((element) => element == '');
    List<String> line = [];
    for (var e in split) {
      final eachLine = e.split(' ');
      if (eachLine.length < 3) {
        eachLine.add(('expense'));
        eachLine.add((0.1).toStringAsFixed(2));
      }
      eachLine.last = checkDouble(eachLine.last.toString())
          ? double.parse(eachLine.last.toString()).toStringAsFixed(2)
          : eachLine.last.toString() + ' 0.10';
      eachLine.removeWhere((element) => element == '');
      final newLine = eachLine.join('#');
      line.add(newLine);
    }
    return line.join(',');
  }

  bool checkDouble(String text) {
    try {
      double.parse(text);
      return true;
    } on Exception {
      return false;
    }
  }

// get total of each entry
  static double getEntryTotal(Entry entry) {
    final split = entry.text.split("\n");
    split.remove('');

    double total = 0.0;
    try {
      for (var element in split) {
        final replace = element.replaceAll(' ', '#');
        final entry = replace.split('#');
        final price = entry.last;
        total += double.tryParse(price) ?? 0.1;
      }
    } catch (err) {
      throw Exception('invalid input');
    }
    return total;
  }

//organize overall spent type (tng, bank, cash, other)
  static List<EntryTypeChart> getEntryType(Entry entry) {
    final split = entry.text.split('\n');

    List<EntryTypeChart> entryTypeChart = [];
    try {
      for (var element in split) {
        final replace = element.replaceAll(' ', '#');
        final ent = replace.split('#');
        final typeStr = ent[0].toLowerCase();
        EntryType type;
        switch (typeStr) {
          case 'tng':
            type = EntryType.tng;
            break;
          case 'bank':
            type = EntryType.bank;
            break;
          case 'cash':
            type = EntryType.cash;
            break;
          default:
            type = EntryType.other;
            break;
        }
        final price = double.parse(ent[ent.length - 1]);
        ent.removeLast();
        ent.remove(ent[0]);
        final text = ent.join(' ');
        entryTypeChart.add(EntryTypeChart(
            id: entry.id,
            type: type,
            entry: text,
            dateTime: entry.date,
            total: price));
      }
    } catch (err) {
      throw Exception('invalid input');
    }
    return entryTypeChart;
  }

  void setCategories(listCategories) {
    categories = listCategories;
  }
}
