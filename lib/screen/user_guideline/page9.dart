import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class Page9 extends StatelessWidget {
  const Page9({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: deviceSize.height * 0.15),
          child: const Image(
            image: AssetImage('assets/guideline gif/guideline8.gif'),
            height: 300,
          ),
        ),
        SizedBox(
          width: deviceSize.width * 0.76,
          child: const Text(
            'Lastly, "Tap" to view your entry, while "Long Tap" to edit your entry',
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
            position: 8,
          ),
        ),
      ],
    );
  }
}
