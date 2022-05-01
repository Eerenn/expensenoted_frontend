import 'package:expensenoted/constant.dart';
import 'package:expensenoted/modal/entry_chart.dart';
import 'package:expensenoted/providers/entry_provider.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SpentTypeBar extends StatefulWidget {
  SpentTypeBar({
    Key? key,
    required this.deviceSize,
    required this.entries,
    required this.selected,
  }) : super(key: key);

  final Size deviceSize;
  final Entries entries;
  DateTime selected;

  @override
  State<SpentTypeBar> createState() => _SpentTypeBarState();
}

class _SpentTypeBarState extends State<SpentTypeBar> {
  @override
  Widget build(BuildContext context) {
    const height = 25.0;
    return Flex(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      direction: Axis.horizontal,
      children: [
        SizedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorBar1,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          height: height,
          width: (widget.deviceSize.width *
                  widget.entries
                      .getEntryTypeChart(
                          widget.entries.getEntries, widget.selected)
                      .overallSpent(EntryType.bank)) *
              0.8,
        ),
        SizedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorBar2,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          height: height,
          width: (widget.deviceSize.width *
                  widget.entries
                      .getEntryTypeChart(
                          widget.entries.getEntries, widget.selected)
                      .overallSpent(EntryType.cash)) *
              0.8,
        ),
        SizedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorBar3,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          height: height,
          width: (widget.deviceSize.width *
                  widget.entries
                      .getEntryTypeChart(
                          widget.entries.getEntries, widget.selected)
                      .overallSpent(EntryType.tng)) *
              0.8,
        ),
        SizedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorBar4,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          height: height,
          width: (widget.deviceSize.width *
                  widget.entries
                      .getEntryTypeChart(
                          widget.entries.getEntries, widget.selected)
                      .overallSpent(EntryType.other)) *
              0.8,
        ),
      ],
    );
  }
}
