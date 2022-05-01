import 'package:expensenoted/modal/entry_modal.dart';
import 'package:expensenoted/widget/entry_toggle_pick_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleEntryScreen extends StatelessWidget {
  const SingleEntryScreen({
    Key? key,
    required this.index,
    required this.entry,
  }) : super(key: key);

  final int index;
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM dd, yyyy').format(entry.date);
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        body: Ink(
          color: Theme.of(context).colorScheme.onBackground,
          child: SizedBox.expand(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 22.0),
                        child: Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Hero(
                      tag: 'entry$index',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 15.0),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                              height: deviceSize.height / 3,
                              width: deviceSize.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 15.0,
                                ),
                                child: Text(entry.text),
                              )),
                        ),
                      ),
                    ),
                    EntryTogglePick(
                      deviceSize: deviceSize,
                      entry: entry,
                      entryAction: EntryAction.viewDetail,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
