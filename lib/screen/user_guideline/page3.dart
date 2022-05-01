import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: deviceSize.height * 0.15),
          child: const Image(
            image: AssetImage('assets/guideline gif/guideline2.gif'),
            height: 300,
          ),
        ),
        SizedBox(
          height: 100,
          width: deviceSize.width * 0.76,
          child: const Text(
            'Select the date of your spending',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 1,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: deviceSize.height * 0.08),
          child: DotsIndicator(
            dotsCount: 9,
            position: 2,
          ),
        ),
      ],
    );
  }
}
