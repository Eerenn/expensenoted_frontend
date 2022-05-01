import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleSignInAPI {
  static final _googleSignIn = GoogleSignIn.standard(
    scopes: [
      // drive.DriveApi.driveAppdataScope,
      // drive.DriveApi.driveFileScope,
    ],
  );
  Future<GoogleSignInAccount?> handleSignIn() async {
    try {
      final result = await _googleSignIn
          .signIn()
          .onError((error, stackTrace) => throw Exception('sign in null'));
      return result;
    } catch (err) {
      throw Exception(err);
    }
  }

  void handleSignOut() {
    try {
      _googleSignIn.signOut();
    } catch (err) {
      throw Exception(err);
    }
  }
}
