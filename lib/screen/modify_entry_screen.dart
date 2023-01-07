import 'package:expensenoted/constant.dart';
import 'package:expensenoted/modal/entry_modal.dart';
import 'package:expensenoted/screen/overview_screen.dart';
import 'package:expensenoted/screen/user_guideline_screen.dart';
import 'package:expensenoted/widget/entry_input_field_widget.dart';
import 'package:expensenoted/widget/entry_toggle_pick_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModifyEntryScreen extends StatelessWidget {
  const ModifyEntryScreen({
    Key? key,
    required this.index,
    required this.entry,
    required this.action,
    required this.cb,
  }) : super(key: key);

  final int index;
  final Entry entry;
  final EntryAction action;

  final Function(bool) cb;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final formattedDate = DateFormat('MMMM dd, yyyy').format(entry.date);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            formattedDate,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          actions: [
            action == EntryAction.editExisting
                ? IconButton(
                    onPressed: (() async {
                      await entry.deleteEntry(entry);

                      //callback force entry refresh
                      await cb(true);
                      Navigator.pushReplacementNamed(
                          context, OverviewScreen.routeName);
                    }),
                    icon: const Icon(
                      Icons.delete,
                      color: colorBar1,
                      size: 26,
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.help_outline_rounded,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    onPressed: () => Navigator.pushNamed(
                        context, UserGuidelineScreen.routeName),
                  ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: deviceSize.width * 0.03),
              child: IconButton(
                onPressed: (() async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  action == EntryAction.editExisting
                      ? await entry.updateEntry(entry)
                      : entry.text.isNotEmpty
                          ? await entry.createEntry(entry)
                          : null;

                  //callback force entry refresh
                  await cb(true);
                  Navigator.pushReplacementNamed(
                      context, OverviewScreen.routeName);
                }),
                icon: Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 26,
                ),
              ),
            )
          ],
        ),
        body: Ink(
          color: Theme.of(context).colorScheme.onBackground,
          child: SizedBox.expand(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EntryInputField(
                      index: index,
                      deviceSize: deviceSize,
                      entry: entry,
                      entryAction: action,
                    ),
                    EntryTogglePick(
                      deviceSize: deviceSize,
                      entry: entry,
                      entryAction: EntryAction.editExisting,
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
