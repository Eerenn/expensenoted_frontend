import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: IOSAccessibility.first_unlock);

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  static const _storage = FlutterSecureStorage();

  Future<void> writeToken(value) async {
    await _storage.write(
      key: dotenv.env['tokenKey'].toString(),
      value: value,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
    // print('object stored.');
  }

  static Future<void> writePreferenceMethod(value) async {
    await _storage.write(
      key: dotenv.env['preferenceMethod'].toString(),
      value: value.toString(),
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  Future<dynamic> readAllToken() async {
    final all = await _storage.readAll(
        iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
    return all;
  }

  static Future<String?> readToken() async {
    return await _storage.read(
        key: dotenv.env['tokenKey'].toString(),
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
  }

  static Future<String?> readPreferenceMethod() async {
    return await _storage.read(
        key: dotenv.env['preferenceMethod'].toString(),
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
  }

  static Future<void> removeToken() async {
    return await _storage.delete(
        key: dotenv.env['tokenKey'].toString(),
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
  }
}
