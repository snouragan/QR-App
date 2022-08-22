import 'package:flutter/material.dart';

import 'package:qrgen/utils/communication.dart';
import 'package:qrgen/utils/display.dart';
import 'package:qrgen/views/login_view.dart';

import 'package:qrgen/widgets/lab_list.dart';
import 'package:qrgen/widgets/settings.dart';

import '../utils/preferences.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key, required this.themeCallback}) : super(key: key);

  final Function themeCallback;

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
      final theme = await Preferences.getTheme();
      widget.themeCallback(theme);

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
                ? LabList(themeCallback: widget.themeCallback)
                : Settings(
                    user: _user, loggedIn: _loggedIn, logoutCallback: _logOut, themeCallback: widget.themeCallback,),
      ),
      bottomNavigationBar: _loggedIn
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code, size: 40), label: 'Labs'),
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
