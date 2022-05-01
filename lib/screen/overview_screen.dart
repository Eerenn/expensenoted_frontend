import 'package:expensenoted/screen/user_guideline_screen.dart';
import 'package:expensenoted/widget/btn_nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:expensenoted/providers/entry_provider.dart';
import 'package:expensenoted/widget/entries_list_widget.dart';
import 'package:provider/provider.dart';

import 'pick_date_screen.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);
  static const routeName = '/overview';

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  double height = 57;
  final _pageController = PageController(
    initialPage: 0,
  );
  final _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final entries = Provider.of<Entries>(context);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.help_outline_rounded,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, UserGuidelineScreen.routeName),
            ),
          )
        ],
        centerTitle: true,
        title: Container(),
        // const Padding(
        //   padding: EdgeInsets.symmetric(vertical: 20.0),
        //   child: Hero(
        //     tag: 'logo',
        //     child: Image(
        //       image: AssetImage('assets/custom/app_logo.png'),
        //       height: 50,
        //     ),
        //   ),
        // ),
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
      ),
      body: SafeArea(
        child: PageView(
          onPageChanged: (value) {
            if (value == 1) {
              setState(() {
                height = 0;
              });
            } else {
              setState(() {
                height = 57;
              });
            }
          },
          controller: _pageController,
          children: [
            Ink(
              color: Theme.of(context).colorScheme.onBackground,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  EntriesList(entries: entries, deviceSize: deviceSize)
                ],
              ),
            ),
            PickDateScreen(deviceSize: deviceSize),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: height,
        child: BtmNavBar(selectedIndex: _selectedIndex),
      ),
    );
  }
}
