import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:expensenoted/api/google_api.dart';
import 'package:http/http.dart' as http;
import 'package:expensenoted/constant.dart';
import 'package:expensenoted/interceptor.dart';
import 'package:expensenoted/secure_storage.dart';

class User with ChangeNotifier, GoogleSignInAPI, SecureStorage {
  String _email;
  String _displayName;
  String? _photoUrl;

  User({
    email,
    displayName,
    photoUrl,
  })  : _email = email,
        _displayName = displayName,
        _photoUrl = photoUrl;

  String get getEmail => _email;
  String get getDisplayName => _displayName;
  String get getPhotoUrl => _photoUrl ?? '';
  Future<String?> get getStorageToken async => await SecureStorage.readToken();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
    );
  }

  final httpI = InterceptedHttp.build(interceptors: [
    LoggingInterceptor(),
  ]);

  Future<bool> getUserFromToken(token) async {
    Uri uri = Uri.parse('$domain/users/auth');
    try {
      final response = await httpI.get(uri).timeout(
            const Duration(seconds: 6),
          );
      if (response.statusCode == 200) {
        User user = User.fromJson(jsonDecode(response.body));
        setUser(user);
      }
    } on SocketException catch (_) {
    } catch (err) {
      Exception(err);
    }
    return _email != '' ? true : false;
  }

  Future<User> googleSignIn() async {
    final account = await handleSignIn();
    Uri uri = Uri.parse('$domain/users/auth/google/callback');
    if (account == null) return User(email: '', displayName: '', photoUrl: '');

    Map<String, String> mapUser = {
      'email': account.email,
      'displayName': account.displayName.toString(),
      'photoUrl': account.photoUrl.toString(),
    };

    User user = User(displayName: '', email: '', photoUrl: '');
    try {
      final response = await http
          .post(uri, headers: header, body: json.encode({'user': mapUser}))
          .timeout(
            const Duration(seconds: 6),
          )
          .onError((error, stackTrace) {
        throw Exception(error);
      }); //post user to backend
      if (response.statusCode != 201) {
        return throw Exception('Google Service error');
      }

      await writeToken(response.body);
      //set access token to local secure storage
      user = User(
        email: account.email,
        displayName: account.displayName,
        photoUrl: account.photoUrl,
      );
      setUser(user);
    } on SocketException catch (_) {
    } catch (err) {
      Exception(err);
    }
    return user;
  }

  void googleLogOut() {
    handleSignOut();
    SecureStorage.removeToken();
    return setUser(User(displayName: '', email: '', photoUrl: ''));
  }

  void setUser(User user) {
    _email = user._email;
    _displayName = user._displayName;
    _photoUrl = user._photoUrl;
    notifyListeners();
  }
}
