import 'dart:convert';
import 'dart:io';

import 'package:qrgen/classes/qrcode.dart';
import 'package:qrgen/exceptions/communcation_exception.dart';
import 'package:qrgen/utils/preferences.dart';
import 'package:http/http.dart' as http;

import '../classes/lab.dart';
import '../values.dart';

class Communication {
  static Future<bool> logIn(String username, String password) async {
    final response = await http.get(Uri.parse('${Values.serverAddress}/login'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $username:$password'
        }).timeout(const Duration(seconds: 3), onTimeout: () {
      throw const CommunicationException(message: 'Cannot connect to server');
    });

    if (response.statusCode == 200) {
      Preferences.setUsername(username);
      Preferences.setPassword(password);
      return true;
    } else {
      throw const CommunicationException(message: 'Failed to login');
    }
  }

  static Future<bool> logInWithSavedCredentials() async {
    final String username = await Preferences.getUsername();
    final String password = await Preferences.getPassword();

    if (username == '' || password == '') {
      throw const CommunicationException(message: 'No account found');
    }

    return await logIn(username, password);
  }

  static Future<bool> logOut() async {
    Preferences.setUsername('');
    Preferences.setPassword('');
    return true;
  }

  static Future<List<QRCode>> requestCodes() async {
    final String username = await Preferences.getUsername();
    final String password = await Preferences.getPassword();

    if (username == '' || password == '') {
      throw const CommunicationException(message: 'Invalid credentials');
    }

    final response = await http.get(Uri.parse('${Values.serverAddress}/codes'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $username:$password'
        }).timeout(const Duration(seconds: 3), onTimeout: () {
      throw const CommunicationException(message: 'Cannot connect to server');
    });

    if (response.statusCode == 200) {
      final List<dynamic> codeList = jsonDecode(response.body);
      return codeList.map((c) => QRCode.fromJson(c)).toList();
    } else {
      throw const CommunicationException(message: 'Failed to load codes');
    }
  }

  static Future<List<Lab>> requestLabs() async {
    final String username = await Preferences.getUsername();
    final String password = await Preferences.getPassword();

    if (username == '' || password == '') {
      throw const CommunicationException(message: 'Invalid credentials');
    }

    final response = await http.get(Uri.parse('${Values.serverAddress}/labs'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $username:$password'
        }).timeout(const Duration(seconds: 3), onTimeout: () {
      throw const CommunicationException(message: 'Cannot connect to server');
    });

    if (response.statusCode == 200) {
      final List<dynamic> labList = jsonDecode(response.body);
      return labList.map((c) => Lab.fromJson(c)).toList();
    } else {
      throw const CommunicationException(message: 'Failed to load labs');
    }
  }

  static Future<void> joinLab(String code) async {
    final String username = await Preferences.getUsername();
    final String password = await Preferences.getPassword();

    if (username == '' || password == '') {
      throw const CommunicationException(message: 'Invalid credentials');
    }

    final response = await http
        .get(Uri.parse('${Values.serverAddress}/labs/join/$code'), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $username:$password'
    }).timeout(const Duration(seconds: 3), onTimeout: () {
      throw const CommunicationException(message: 'Cannot connect to server');
    });

    if (response.statusCode != 200) {
      throw const CommunicationException(message: 'Failed to join lab');
    }
  }

  static Future<Lab> kickParticipant(Lab lab, int participant) async {
    final String username = await Preferences.getUsername();
    final String password = await Preferences.getPassword();

    if (username == '' || password == '') {
      throw const CommunicationException(message: 'Invalid credentials');
    }

    final response = await http.get(
        Uri.parse('${Values.serverAddress}/labs/kick/${lab.id}/$participant'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $username:$password'
        }).timeout(const Duration(seconds: 3), onTimeout: () {
      throw const CommunicationException(message: 'Cannot connect to server');
    });

    if (response.statusCode == 200) {
      return Lab.fromJson(jsonDecode(response.body));
    } else {
      throw const CommunicationException(message: 'Failed to kick participant');
    }
  }
}
