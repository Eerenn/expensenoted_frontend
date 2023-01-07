import 'package:expensenoted/modal/entry_modal.dart';
import 'package:expensenoted/screen/modify_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PickDateWidget extends StatelessWidget {
  const PickDateWidget({
    Key? key,
    required this.deviceSize,
    required this.day,
  }) : super(key: key);

  final Size deviceSize;
  final String day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: () {
            switch (day) {
              case 'Yesterday':
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ModifyEntryScreen(
                        index: 0,
                        entry: Entry(
                          date:
                              DateTime.now().subtract(const Duration(days: 1)),
                          categories: [],
                          text: '',
                          worthiness: Worthiness.worth,
                          id: '',
                        ),
                        action: EntryAction.createNew,
                        cb: (force) {},
                      ),
                    ),
                  );
                }
                break;

              case 'Today':
                {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ModifyEntryScreen(
                        index: 0,
                        entry: Entry(
                          date: DateTime.now(),
                          categories: [],
                          text: '',
                          worthiness: Worthiness.worth,
                          id: '',
                        ),
                        action: EntryAction.createNew,
                        cb: (force) {},
                      ),
                    ),
                  );
                }
                break;

              case 'Other Day':
                {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2021, 1, 1),
                      maxTime: DateTime.now(),
                      theme: DatePickerTheme(
                        backgroundColor:
                            Theme.of(context).colorScheme.onBackground,
                      ),
                      onChanged: (date) {}, onConfirm: (date) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ModifyEntryScreen(
                          index: 0,
                          entry: Entry(
                            date: date,
                            categories: [],
                            text: '',
                            worthiness: Worthiness.worth,
                            id: '',
                          ),
                          action: EntryAction.createNew,
                          cb: (force) {},
                        ),
                      ),
                    );
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                }
                break;
            }
          },
          child: Container(
            color: Colors.transparent,
            height: deviceSize.height / 3 - (deviceSize.height / 10),
            width: deviceSize.width,
            child: Center(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: deviceSize.width / 6,
                  ),
                  Image(
                    color: Theme.of(context).colorScheme.secondary,
                    image: AssetImage(
                        'assets/categories/${day.toLowerCase()}.png'),
                    height: 50,
                  ),
                  SizedBox(
                    width: deviceSize.width / 6,
                  ),
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 26,
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
