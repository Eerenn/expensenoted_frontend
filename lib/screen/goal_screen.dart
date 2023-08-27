import 'package:expensenoted/providers/entry_provider.dart';
import 'package:expensenoted/widget/btn_nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);
  static const routeName = '/spentType';

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final DateTime? _selected = DateTime.now();
  final _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final entries = Provider.of<Entries>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('Add Goal'),
        ),
      ),

      // SingleChildScrollView(
      //   child: SizedBox(
      //     height: entries
      //             .getTopEntry(entries.getEntries, _selected!)
      //             .entryTypeList
      //             .length *
      //         80,
      //     child: ListView.builder(
      //       physics: const NeverScrollableScrollPhysics(),
      //       itemCount: entries
      //           .getTopEntry(entries.getEntries, _selected!)
      //           .entryTypeList
      //           .length,
      //       itemBuilder: (context, index) {
      //         return Padding(
      //           padding: const EdgeInsets.symmetric(
      //             horizontal: 12.0,
      //             vertical: 4.0,
      //           ),
      //           child: Card(
      //             elevation: 4,
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(
      //                   vertical: 20, horizontal: 20),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Text(
      //                     formatDate(
      //                         'dd MMMM',
      //                         entries
      //                             .getTopEntry(entries.getEntries, _selected!)
      //                             .entryTypeList[index]
      //                             .dateTime),
      //                   ),
      //                   Text(entries
      //                       .getTopEntry(entries.getEntries, _selected!)
      //                       .entryTypeList[index]
      //                       .entry),
      //                   Text(
      //                       '${entries.getTopEntry(entries.getEntries, _selected!).entryTypeList[index].total}'),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //   ),
      // ),
      bottomNavigationBar: BtmNavBar(selectedIndex: _selectedIndex),
    );
  }

  String formatDate(String format, DateTime dt) {
    return DateFormat(format).format(dt);
  }
}
