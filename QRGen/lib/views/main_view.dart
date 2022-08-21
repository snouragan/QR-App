import 'package:flutter/material.dart';

import 'package:qrgen/utils/communication.dart';
import 'package:qrgen/utils/display.dart';
import 'package:qrgen/views/login_view.dart';

import 'package:qrgen/widgets/lab_list.dart';
import 'package:qrgen/widgets/settings.dart';
import 'package:qrgen/widgets/qr_list.dart';

import '../utils/preferences.dart';


class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String _user = '';
  bool _loggedIn = true;

  int _viewIndex = 0;

  Future<void> _logIn(usr, pwd) async {
    try {
      await Communication.logIn(usr, pwd);

      setState(() {
        _loggedIn = true;
        _user = usr;
        _viewIndex = 0;
      });
    } on Exception catch (e) {
      Display.showDismissibleSnackBar(context, e.toString());
    }
  }

  Future<void> _logOut() async {
    try {
      await Communication.logOut();

      setState(() {
        _user = '';
        _loggedIn = false;
      });
    } on Exception catch (e) {
      Display.showDismissibleSnackBar(context, e.toString());
    }
  }

  // NAVIGATION BAR
  void _navBarTap(int index) {
    setState(() {
      _viewIndex = index;
    });
  }

  Future<void> _init() async {
    try {
      await Communication.logInWithSavedCredentials();
      String usr = await Preferences.getUsername();

      setState(() {
        _loggedIn = true;
        _user = usr;
        _viewIndex = 0;
        Display.showDismissibleSnackBar(context, 'Logged in as $_user');
      });
    } on Exception catch (e) {
      Display.showDismissibleSnackBar(context, e.toString());
      setState(() {
        _loggedIn = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loggedIn = true;
    });
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: !_loggedIn
            ? LoginView(logInCallback: _logIn)
            : _viewIndex == 0
                ? const QRList()
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
