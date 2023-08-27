import 'dart:convert';

import 'package:expensenoted/modal/entry_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:expensenoted/constant.dart';
import 'package:expensenoted/interceptor.dart';
import 'package:expensenoted/modal/entry_modal.dart';

class Entries with ChangeNotifier {
  final List<Entry> _entries = [];
  final List<Entry> _partialEntries = [];

  List<Entry> get getEntries {
    return [..._entries];
  }

  List<Entry> get getPartialEntries {
    return [..._partialEntries];
  }

  final httpI = InterceptedHttp.build(interceptors: [
    LoggingInterceptor(),
  ]);

  Future getUserEntries() async {
    Uri uri = Uri.parse('$domain/entries/all');

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

  bool getMonthByListIsEmpty(DateTime date) {
    return _entries
        .where((element) =>
            element.date.year == date.year && element.date.month == date.month)
        .toList()
        .isEmpty;
  }

  Future getUserPartialEntries(int? month) async {
    Uri uri = Uri.parse('$domain/entries/partial?month=$month');

    try {
      final response = await httpI.get(uri);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        List<Entry> entriesList =
            (json as List).map((e) => Entry.fromJson(e)).toList();
        entriesList.sort(
          (a, b) => b.date.compareTo(
            a.date,
          ),
        );

        _partialEntries.clear();
        _partialEntries.addAll(entriesList
            .where((entry) => _partialEntries.every((e) => entry.id != e.id)));
        notifyListeners();
      }
    } catch (_) {}
  }

//filter entries by month
  Future<List<Entry>> filterByMonth(DateTime dateTime) async {
    Uri uri = Uri.parse('$domain/entries/date?date=$dateTime');

    try {
      final response = await httpI.get(uri);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        List<Entry> entriesList =
            (json as List).map((e) => Entry.fromJson(e)).toList();
        entriesList.sort(
          (a, b) => b.date.compareTo(
            a.date,
          ),
        );
        _entries.addAll(entriesList
            .where((entry) => _entries.every((e) => entry.id != e.id)));

        notifyListeners();
      }
    } catch (_) {
    } finally {
      return _entries;
    }
  }

  Future<List<Entry>> refreshSelectedMonth(DateTime dateTime) async {
    _entries.forEach((element) {
      if (element.date.month == dateTime.month &&
          element.date.year == dateTime.year) {
        _entries.remove(element);
      }
    });

    filterByMonth(dateTime);

    return _entries;
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
      List<Entry> entries, DateTime selected) {
    EntryTypeMonthChart chart = entriesByMonth(entries, selected);
    chart.entryTypeList = chart.recalculatePaymentModeTotal();

    return chart;
  }

  EntryTypeMonthChart entriesByMonth(List<Entry> entries, DateTime selected) {
    EntryTypeMonthChart entryTypeMonthChart =
        EntryTypeMonthChart(entryTypeList: List.empty(growable: true));

    for (Entry ent in entries) {
      if (ent.date.month == selected.month && ent.date.year == selected.year) {
        entryTypeMonthChart.entryTypeList.addAll(Entry.getEntryType(ent));
      }
    }
    return entryTypeMonthChart;
  }

//construct list (breakdown entries into lines and sort based on highest spent)
  EntryTypeMonthChart getTopEntry(List<Entry> entries, DateTime dateTime) {
    EntryTypeMonthChart entryTypeMonthChart = EntryTypeMonthChart(
      entryTypeList: [],
    );

    for (Entry ent in entries.where((element) =>
        element.date.month == dateTime.month &&
        element.date.year == dateTime.year)) {
      entryTypeMonthChart.entryTypeList.addAll(Entry.getEntryType(ent));
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

  Entry findEntryFromSortedEntryType(List<EntryTypeChart> typeList, int index) {
    return _entries.firstWhere((element) => element.id == typeList[index].id);
  }

  void clearEntriesCache() {
    _entries.clear();
    _partialEntries.clear();
    notifyListeners();
  }
}
