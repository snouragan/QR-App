import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrgen/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'package:qrgen/widgets/lab_list.dart';
import 'package:qrgen/widgets/settings.dart';
import 'package:qrgen/widgets/qr_list.dart';

import '../classes/qrcode.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String _user = '';
  String _password = '';
  bool _loggedIn = false;

  int _viewIndex = 0;

  List<QRCode> _codes = [];
  late Future<void> _initCodes;

  // USER PREFERENCES
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = (prefs.getString('user') ?? '');
      _password = (prefs.getString('password') ?? '');
    });
  }

  Future<void> _savePreferences(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', 'janelu44');
    await prefs.setString('password', '12345678');
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved preferences')));
  }

  Future<void> _clearPreferences(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cleared preferences')));
  }

  Future<void> _logIn(usr, pwd) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/login'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $usr:$pwd'
        }).timeout(const Duration(seconds: 3), onTimeout: () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: const Text("Failed to login. Please try again."),
        action: SnackBarAction(
          label: 'DISMISS',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ));
      setState(() {
        _loggedIn = false;
      });

      return http.Response('Failed to login. Please try again.', 408);
    });

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user', usr);
      prefs.setString('password', pwd);
      setState(() {
        if (_user == '' || _password == '') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Logged in as $usr')));
        }
        _user = usr;
        _password = pwd;
        _loggedIn = true;
        _viewIndex = 0;
        _refreshCodes();
      });
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> _logOut() async {
    setState(() {
      _user = '';
      _password = '';
      _loggedIn = false;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', '');
    await prefs.setString('password', '');
  }

  // QR CODES
  Future<void> _refreshCodes() async {
    final cds = await _fetchCodes();
    setState(() {
      _codes = cds;
    });
  }

  Future<List<QRCode>> _fetchCodes() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/codes'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_user:$_password'
        }).timeout(const Duration(seconds: 3), onTimeout: () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: const Text("Cannot connect to server"),
        action: SnackBarAction(
          label: 'DISMISS',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ));
      return http.Response('Cannot connect to server', 408);
    });

    if (response.statusCode == 200) {
      final List<dynamic> codeList = jsonDecode(response.body);
      return codeList.map((c) => QRCode.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load codes');
    }
  }

  // NAVIGATION BAR
  void _navBarTap(int index) {
    setState(() {
      _viewIndex = index;
    });
  }

  Future<void> _initialize() async {
    _initCodes = dummyFuture();
    await _loadPreferences();
    if (_user != '' && _password != '') {
      await _logIn(_user, _password);
      await _refreshCodes();
    }
  }

  Future<void> dummyFuture() async {}

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: !_loggedIn
            ? LoginView(loggedIn: _loggedIn, logInCallback: _logIn)
            : _viewIndex == 0
                ? FutureBuilder(
                    future: _initCodes,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        case ConnectionState.done:
                          {
                            return RefreshIndicator(
                                onRefresh: _refreshCodes,
                                child: QRList(
                                  codes: _codes,
                                  user: _user,
                                ));
                          }
                      }
                    })
                : _viewIndex == 1
                    ? const LabList()
                    : Settings(
                        user: _user,
                        loggedIn: _loggedIn,
                        logoutCallback: _logOut),
      ),
      bottomNavigationBar: _loggedIn
          ? BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code, size: 40), label: 'Codes'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month, size: 40), label: 'Labs'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      size: 40,
                    ),
                    label: 'Settings'),
              ],
              currentIndex: _viewIndex,
              onTap: _navBarTap,
            )
          : const SizedBox(
              height: 0,
            ),
    );
  }
}
