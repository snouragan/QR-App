import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static const String usernameKey = 'username';
  static const String passwordKey = 'password';
  static const String tokenKey = 'token';

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(usernameKey) ?? '');
  }

  static Future<void> setUsername(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(usernameKey, value);
  }

  static Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(passwordKey) ?? '');
  }

  static Future<void> setPassword(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(passwordKey, value);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(tokenKey) ?? '');
  }

  static Future<void> setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, value);
  }
}