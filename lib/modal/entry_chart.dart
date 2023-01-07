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
  EntryType type;
  String entry;
  double total;
  DateTime dateTime;

  EntryTypeChart({
    required this.type,
    required this.entry,
    required this.total,
    required this.dateTime,
  });
}

class EntryTypeMonthChart {
  List<EntryTypeChart> entryTypeList;
  DateTime month;

  EntryTypeMonthChart({
    required this.entryTypeList,
    required this.month,
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
}
