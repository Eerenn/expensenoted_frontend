import 'package:flutter/material.dart';
import 'package:expensenoted/screen/loading_screen.dart';
import 'package:provider/provider.dart';

import '../api/google_api.dart';
import '../providers/auth_provider.dart';

// ignore: must_be_immutable
class GoogleSignInButton extends StatefulWidget {
  GoogleSignInButton({
    Key? key,
    required this.cb,
  }) : super(key: key);

  Function(String) cb;

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final googleSignInAPI = GoogleSignInAPI();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[500],
              padding: const EdgeInsets.all(8),
            ),
            onPressed: () async {
              setState(() {
                _isLoading = !_isLoading;
              });
              User user = await Provider.of<User>(context, listen: false)
                  .googleSignIn();
              // widget.cb(user.getEmail);
              final snackBar = SnackBar(
                content: const Text(
                  'Server request timeout, please try again later.',
                ),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    user.googleLogOut();
                    Navigator.pushReplacementNamed(
                        context, LoadingScreen.routeName);
                  },
                ),
                duration: const Duration(minutes: 5),
              );

              if (user.getEmail == '') {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Navigator.pushReplacementNamed(
                    context, LoadingScreen.routeName);
              }
            },
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/300px-Google_%22G%22_Logo.svg.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Sign In With Google',
                  style: TextStyle(color: Colors.white, height: 2),
                ),
              ],
            ),
          );
  }
}
