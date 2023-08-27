import 'package:expensenoted/modal/entry_chart.dart';
import 'package:expensenoted/modal/entry_modal.dart';
import 'package:expensenoted/providers/entry_provider.dart';
import 'package:expensenoted/screen/modify_entry_screen.dart';
import 'package:expensenoted/screen/single_entry_screen.dart';
import 'package:expensenoted/widget/btn_nav_bar_widget.dart';
import 'package:expensenoted/widget/spend_type_bar_widget.dart';
import 'package:expensenoted/widget/spent_type_bar_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);
  static const routeName = '/report';

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _selectedIndex = 1;
  DateTime? _selected = DateTime.now();

  String formatDate(String format, DateTime dt) {
    return DateFormat(format).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final entries = Provider.of<Entries>(context, listen: false);
    final sortedEntries = Provider.of<Entries>(context, listen: true)
        .getTopEntry(entries.getEntries, _selected!)
        .entryTypeList;
    return Scaffold(
      bottomNavigationBar: BtmNavBar(selectedIndex: _selectedIndex),
      body: SafeArea(
        child: Ink(
          color: Theme.of(context).colorScheme.onBackground,
          child: FutureBuilder(
            initialData: entries.getEntries,
            future: entries.filterByMonth(_selected!),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (entries.getMonthByListIsEmpty(_selected!)) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Flex(
                      direction: Axis.vertical,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: TextButton(
                            onPressed: () async {
                              final selected = await showMonthYearPicker(
                                context: context,
                                initialDate: _selected ?? DateTime.now(),
                                firstDate: DateTime(2019),
                                lastDate: DateTime(
                                    DateTime.now().year, DateTime.now().month),
                                locale: const Locale('en'),
                              );
                              if (selected != null) {
                                setState(() {
                                  _selected = selected;
                                });
                              }
                            },
                            child: Text(
                              'Report Month: ${formatDate('MMMM, yyyy', _selected!)}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: deviceSize.height / 4,
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Image(
                            image: AssetImage('assets/custom/vector2.png'),
                            height: 250,
                          ),
                        ),
                        const SizedBox(
                          width: 250,
                          child: Text(
                            'Aww,\nthere\'s no entry for this month',
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Lottie.network(
                          'https://assets2.lottiefiles.com/packages/lf20_OT15QW.json'),
                    );
                  }
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      // direction: Axis.vertical,
                      children: [
                        SizedBox(
                          height: 270,
                          child: SfCircularChart(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            legend: Legend(isVisible: true),
                            title: ChartTitle(
                              text:
                                  'Your spent on ${formatDate('MMMM, yyyy', _selected!)}',
                              textStyle: const TextStyle(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            series: <CircularSeries>[
                              DoughnutSeries<EntryChart, String>(
                                dataSource: entries.getEntryChart(
                                    entries.getEntries, _selected!),
                                xValueMapper: (EntryChart entry, _) =>
                                    formatDate('dd MMMM', entry.date),
                                yValueMapper: (EntryChart entry, _) =>
                                    double.parse(
                                  entry.total.toStringAsFixed(2),
                                ),
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.white,
                                ),
                                explode: true,
                                explodeAll: true,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Your Total Spent This Month:  ',
                                  style: TextStyle(
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  entries
                                      .getMonthlySpent(
                                          entries.getEntries, _selected!)
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                  ),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                onPressed: () async {
                                  final selected = await showMonthYearPicker(
                                    context: context,
                                    initialDate: _selected ?? DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(DateTime.now().year,
                                        DateTime.now().month),
                                    locale: const Locale('en'),
                                    builder: (context, child) {
                                      return Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 100.0),
                                            child: SizedBox(
                                              height: 520,
                                              child: child,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (selected != null) {
                                    setState(() {
                                      _selected = selected;
                                    });
                                  }
                                },
                                child: Text(
                                  'Report Month: ${formatDate('MMMM, yyyy', _selected!)}',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.refresh_outlined,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  })
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Overall Spent Type',
                            style: TextStyle(
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 30),
                          child: SpentTypeBar(
                              deviceSize: deviceSize,
                              entries: entries,
                              selected: _selected!),
                        ),
                        SpentTypeBarInfo(deviceSize: deviceSize),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: deviceSize.height * 0.03,
                              horizontal: 24.0),
                          child: const Text(
                            'Your Top Spent',
                            style: TextStyle(
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sortedEntries.length * 100,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: sortedEntries.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                                child: InkWell(
                                  onDoubleTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => SingleEntryScreen(
                                          index: index,
                                          entry: entries
                                              .findEntryFromSortedEntryType(
                                                  sortedEntries, index),
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => ModifyEntryScreen(
                                          index: index,
                                          entry: entries
                                              .findEntryFromSortedEntryType(
                                                  sortedEntries, index),
                                          action: EntryAction.editExisting,
                                          cb: (bool force) async {
                                            return;
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30, horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formatDate('dd MMMM',
                                                sortedEntries[index].dateTime),
                                          ),
                                          Text(sortedEntries[index].entry),
                                          Text('${sortedEntries[index].total}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Lottie.network(
                      'https://assets2.lottiefiles.com/packages/lf20_OT15QW.json'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
