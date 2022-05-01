import 'dart:convert';

import 'package:expensenoted/modal/entry_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:expensenoted/constant.dart';
import 'package:expensenoted/interceptor.dart';
import 'package:expensenoted/modal/entry_modal.dart';

class Entries with ChangeNotifier {
  final List<Entry> _entries = [];

  List<Entry> get getEntries {
    return [..._entries];
  }

  final httpI = InterceptedHttp.build(interceptors: [
    LoggingInterceptor(),
  ]);

  Future getUserEntries() async {
    Uri uri = Uri.parse('$domain/entries');

    try {
      final response = await httpI.get(uri);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        List<Entry> entriesList =
            (json as List).map((e) => Entry.fromJson(e)).toList();
        _entries.clear();
        entriesList.sort(
          (a, b) => b.date.compareTo(
            a.date,
          ),
        );
        for (Entry entry in entriesList) {
          _entries.add(entry);
        }
        notifyListeners();
      }
    } catch (_) {}
  }

//filter entries by month
  List<Entry> filterByMonth(DateTime dateTime) {
    List<Entry> list = [];
    for (Entry ent in _entries.where((element) =>
        element.date.month == dateTime.month &&
        element.date.year == dateTime.year)) {
      list.add(
        Entry(
          id: ent.id,
          categories: ent.categories,
          text: ent.text,
          worthiness: ent.worthiness,
          date: ent.date,
        ),
      );
    }
    return list;
  }

//build circular chart (breakdown entries into lines then sum total)
  List<EntryChart> getEntryChart(List<Entry> entries, DateTime dateTime) {
    List<EntryChart> list = [];
    for (Entry ent in entries.where((element) =>
        element.date.month == dateTime.month &&
        element.date.year == dateTime.year)) {
      list.add(
        EntryChart(
          date: ent.date,
          total: Entry.getEntryTotal(ent),
        ),
      );
    }

    List<EntryChart> distinctDate = [];

    for (var element in list) {
      if (distinctDate.every((e) => e.date.day != element.date.day)) {
        distinctDate.add(EntryChart(date: element.date, total: 0.0));
      }
    }

    for (var i in list) {
      for (var j in distinctDate) {
        if (i.date.day == j.date.day) {
          j.total += i.total;
        }
      }
    }

    return distinctDate;
  }

//construct bar chart (breakdown all entries into total sum of bank, tng, cash and others)
  EntryTypeMonthChart getEntryTypeChart(
      List<Entry> entries, DateTime dateTime) {
    EntryTypeMonthChart entryTypeMonthChart = EntryTypeMonthChart(
      entryTypeList: [],
      month: DateTime.now(),
    );

    for (Entry ent in entries.where((element) =>
        element.date.month == dateTime.month &&
        element.date.year == dateTime.year)) {
      entryTypeMonthChart.entryTypeList += (Entry.getEntryType(ent));
      entryTypeMonthChart.month = DateTime.now();
    }
    entryTypeMonthChart.entryTypeList =
        Entry.cleanEntryType(entryTypeMonthChart.entryTypeList);

    return entryTypeMonthChart;
  }

//construct list (breakdown entries into lines and sort based on highest spent)
  EntryTypeMonthChart getTopEntry(List<Entry> entries, DateTime dateTime) {
    EntryTypeMonthChart entryTypeMonthChart = EntryTypeMonthChart(
      entryTypeList: [],
      month: DateTime.now(),
    );

    for (Entry ent in entries.where((element) =>
        element.date.month == dateTime.month &&
        element.date.year == dateTime.year)) {
      entryTypeMonthChart.entryTypeList += (Entry.getEntryType(ent));
      entryTypeMonthChart.month = DateTime.now();
    }
    entryTypeMonthChart.entryTypeList.sort(
      (a, b) => a.total.compareTo(b.total),
    );
    entryTypeMonthChart.entryTypeList =
        entryTypeMonthChart.entryTypeList.reversed.toList();

    return entryTypeMonthChart;
  }

  //grap this month overall total spent
  double getMonthlySpent(List<Entry> entries, DateTime dateTime) {
    double total = 0.0;
    List<EntryTypeChart> list = [];

    for (Entry ent in entries.where((element) =>
        element.date.month == dateTime.month &&
        element.date.year == dateTime.year)) {
      list += (Entry.getEntryType(ent));
    }
    for (var item in list) {
      total += item.total;
    }
    return total;
  }
}
