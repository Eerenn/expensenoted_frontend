import 'entry_modal.dart';

class EntryChart {
  DateTime date;
  double total;

  EntryChart({
    required this.date,
    required this.total,
  });
}

enum EntryType { bank, cash, tng, other }

class EntryTypeChart {
  String id;
  EntryType type;
  String entry;
  double total;
  DateTime dateTime;

  EntryTypeChart({
    required this.id,
    required this.type,
    required this.entry,
    required this.total,
    required this.dateTime,
  });
}

class EntryTypeMonthChart {
  List<EntryTypeChart> entryTypeList;
  DateTime date;

  EntryTypeMonthChart({
    required this.entryTypeList,
    required this.date,
  });

  double overallSpent(EntryType et) {
    double total = 0.0;
    for (var element in entryTypeList) {
      total += element.total;
    }
    double typeTotal = entryTypeList
        .firstWhere((element) => element.type.name == et.name)
        .total;

    return typeTotal / total;
  }

  Entry findEntryFromSortedEntryType(List<Entry> entries, int index) {
    return entries
        .firstWhere((element) => element.id == entryTypeList[index].id);
  }
}
