import 'package:flutter/material.dart';
import 'package:expensenoted/widget/pick_date_widget.dart';

class PickDateScreen extends StatelessWidget {
  const PickDateScreen({
    Key? key,
    required this.deviceSize,
  }) : super(key: key);

  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Theme.of(context).colorScheme.onBackground,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              heightFactor: 2,
              child: Text(
                'Select a date',
                style: TextStyle(fontSize: 25),
              ),
            ),
            PickDateWidget(deviceSize: deviceSize, day: 'Yesterday'),
            PickDateWidget(deviceSize: deviceSize, day: 'Today'),
            PickDateWidget(deviceSize: deviceSize, day: 'Other Day'),
          ],
        ),
      ),
    );
  }
}
