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

  EntryTypeMonthChart({
    required this.entryTypeList,
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

  List<EntryTypeChart> recalculatePaymentModeTotal() {
    List<EntryTypeChart> newList = [];
    for (var paymentMode in EntryType.values) {
      EntryTypeChart consolidatedPaymentType = EntryTypeChart(
          id: '',
          type: paymentMode,
          entry: '',
          total: 0.0,
          dateTime: DateTime.now());
      for (EntryTypeChart type in entryTypeList) {
        if (type.type.name == paymentMode.name) {
          consolidatedPaymentType.total += type.total;
        }
      }
      newList.add(consolidatedPaymentType);
    }

    return newList;
  }
}
