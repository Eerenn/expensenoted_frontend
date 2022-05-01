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
        Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox(
              width: deviceSize.height * 0.01,
              height: deviceSize.height * 0.01,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorBar1,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(EntryType.bank.name),
            )
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox(
              width: deviceSize.height * 0.01,
              height: deviceSize.height * 0.01,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorBar2,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(EntryType.cash.name),
            )
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox(
              width: deviceSize.height * 0.01,
              height: deviceSize.height * 0.01,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorBar3,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(EntryType.tng.name),
            )
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox(
              width: deviceSize.height * 0.01,
              height: deviceSize.height * 0.01,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorBar4,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Text(EntryType.other.name),
            )
          ],
        ),
      ],
    );
  }
}
