import 'package:expensenoted/constant.dart';
import 'package:expensenoted/modal/entry_chart.dart';
import 'package:flutter/material.dart';

class SpentTypeBarInfo extends StatelessWidget {
  const SpentTypeBarInfo({
    Key? key,
    required this.deviceSize,
  }) : super(key: key);

  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (EntryType entryType in EntryType.values)
          Flex(
            direction: Axis.horizontal,
            children: [
              SizedBox(
                width: deviceSize.height * 0.01,
                height: deviceSize.height * 0.01,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: getColor(entryType),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(entryType.name),
              )
            ],
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
