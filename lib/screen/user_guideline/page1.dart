import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: deviceSize.height * 0.15),
          child: Image(
            image: const AssetImage('assets/custom/vector3.png'),
            height: deviceSize.aspectRatio * deviceSize.height * 0.55,
          ),
        ),
        Flex(
          direction: Axis.vertical,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 36,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(
              width: deviceSize.width * 0.76,
              child: const Text(
                'Here we strives to keep your spending on track.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: deviceSize.height * 0.08),
          child: DotsIndicator(
            dotsCount: 9,
            position: 0,
          ),
        ),
      ],
    );
  }
}
