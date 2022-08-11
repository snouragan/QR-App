import 'package:flutter/material.dart';
import 'package:qrgen/widgets/page_title.dart';

class Settings extends StatefulWidget {
  const Settings(
      {Key? key,
      required this.user,
      required this.loggedIn,
      required this.logoutCallback})
      : super(key: key);

  final String user;
  final bool loggedIn;
  final Function logoutCallback;

  @override
  State<Settings> createState() => _SettingsState();
}

enum Theme {dark}

class _SettingsState extends State<Settings> {

  Theme _selectedTheme = Theme.dark;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const PageTitle(text: 'Settings'),
        ListTile(
            title: const Text(
              'Account',
              style: TextStyle(fontSize: 24.0),
            ),
            subtitle: Text(
              widget.loggedIn
                  ? 'Logged in as ${widget.user}'
                  : 'Currently not logged in.',
              style: const TextStyle(fontSize: 16.0),
            ),
            leading: const Icon(Icons.account_circle_rounded),
            trailing: widget.loggedIn
                ? TextButton(
                    onPressed: () {
                      widget.logoutCallback();
                    },
                    child: const Text('LOG OUT'))
                : TextButton(onPressed: () {}, child: const Text('LOG IN'))),
        ListTile(
          title: const Text(
            'Theme',
            style: TextStyle(fontSize: 24.0),
          ),
          subtitle: const Text('Change how the application looks'),
          leading: const Icon(Icons.color_lens_rounded),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                    title: const Text('Theme'),
                    content: Radio(
                        value: Theme.dark, groupValue: _selectedTheme, onChanged: (Theme? value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                    })));
          },
        ),
      ],
    );
  }
}
