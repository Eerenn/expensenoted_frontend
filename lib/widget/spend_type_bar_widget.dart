import 'package:expensenoted/constant.dart';
import 'package:expensenoted/modal/entry_chart.dart';
import 'package:expensenoted/providers/entry_provider.dart';
import 'package:flutter/material.dart';

class SpentTypeBar extends StatelessWidget {
  const SpentTypeBar({
    Key? key,
    required this.deviceSize,
    required this.entries,
    required this.selected,
  }) : super(key: key);

  final Size deviceSize;
  final Entries entries;
  final DateTime selected;

  @override
  Widget build(BuildContext context) {
    const height = 25.0;
    return Flex(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      direction: Axis.horizontal,
      children: [
        for (EntryType entryType in EntryType.values)
          Tooltip(
            preferBelow: false,
            triggerMode: TooltipTriggerMode.tap,
            //get from chart total amount of each entryType
            message: entries
                .getEntryTypeChart(entries.getEntries)
                .entryTypeList
                .firstWhere((element) => element.type == entryType)
                .total
                .toStringAsFixed(2),
            child: SizedBox(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: getColor(entryType),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              height: height,
              width: (deviceSize.width *
                      entries
                          .getEntryTypeChart(entries.getEntries)
                          .overallSpent(entryType)) *
                  0.8,
            ),
          ),
      ],
    );
  }

  Color getColor(EntryType entryType) {
    switch (entryType) {
      case EntryType.bank:
        return colorBar1;
      case EntryType.cash:
        return colorBar2;
      case EntryType.tng:
        return colorBar3;
      case EntryType.other:
        return colorBar4;
    }
  }
}
