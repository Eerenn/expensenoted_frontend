import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: deviceSize.height * 0.08),
          child: const Image(
            image: AssetImage('assets/guideline gif/guideline3.gif'),
            height: 300,
          ),
        ),
        SizedBox(
          width: deviceSize.width * 0.76,
          child: const Text(
            'Input all your expense record line by line with format below\n[type] [description] [amount]\nFor example:\ncash purchase 10.90',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 1,
              height: 1.9,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: deviceSize.height * 0.08),
          child: DotsIndicator(
            dotsCount: 9,
            position: 3,
          ),
        ),
      ],
    );
  }
}
