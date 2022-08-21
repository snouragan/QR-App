import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static const String usernameKey = 'username';
  static const String passwordKey = 'password';

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
}