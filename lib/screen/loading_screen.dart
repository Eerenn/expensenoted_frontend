import 'package:flutter/material.dart';
import 'package:expensenoted/screen/auth_screen.dart';
import 'package:expensenoted/screen/overview_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);
  static const routeName = '/loading';

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  void _asyncMethod() async {
    final user = Provider.of<User>(context, listen: false);
    final token = await user.getStorageToken;

    final snackBar = SnackBar(
      content: const Text('Server request timeout, please try again later.'),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {
          user.googleLogOut();
          _asyncMethod();
        },
      ),
      duration: const Duration(minutes: 5),
    );
    if (token != null) {
      final getUser = await user.getUserFromToken(token);
      getUser
          ? Navigator.pushReplacementNamed(context, OverviewScreen.routeName)
          : ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pushReplacementNamed(context, AuthScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        color: Theme.of(context).colorScheme.onBackground,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 120),
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
        ),
      ),
    );
  }
}
