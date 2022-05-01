import 'package:expensenoted/screen/user_guideline/page1.dart';
import 'package:expensenoted/screen/user_guideline/page2.dart';
import 'package:expensenoted/screen/user_guideline/page3.dart';
import 'package:expensenoted/screen/user_guideline/page4.dart';
import 'package:expensenoted/screen/user_guideline/page5.dart';
import 'package:expensenoted/screen/user_guideline/page6.dart';
import 'package:expensenoted/screen/user_guideline/page7.dart';
import 'package:expensenoted/screen/user_guideline/page8.dart';
import 'package:expensenoted/screen/user_guideline/page9.dart';
import 'package:flutter/material.dart';

class UserGuidelineScreen extends StatefulWidget {
  const UserGuidelineScreen({Key? key}) : super(key: key);
  static const routeName = '/user_guideline';

  @override
  State<UserGuidelineScreen> createState() => _UserGuidelineScreenState();
}

class _UserGuidelineScreenState extends State<UserGuidelineScreen> {
  final _pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 20,
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
      ),
      body: Ink(
        color: Theme.of(context).colorScheme.onBackground,
        child: SafeArea(
          child: PageView(
            controller: _pageController,
            children: const [
              Page1(),
              Page2(),
              Page3(),
              Page4(),
              Page5(),
              Page6(),
              Page7(),
              Page8(),
              Page9(),
            ],
          ),
        ),
      ),
    );
  }
}
