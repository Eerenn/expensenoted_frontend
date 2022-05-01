import 'package:flutter/material.dart';

import 'package:expensenoted/widget/google_signin_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Ink(
          color: Theme.of(context).colorScheme.onBackground,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 140),
                  child: Hero(
                    tag: 'logo',
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: const Image(
                          image: AssetImage('assets/custom/app_logo.png'),
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                ),
                GoogleSignInButton(
                  cb: (String displayName) {
                    // print(displayName);
                    // Navigator.of(context)
                    // .pushReplacementNamed(LoadingScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
