import 'package:flutter/material.dart';
import 'package:qrgen/utils/preferences.dart';
import 'package:qrgen/widgets/page_title.dart';

class Settings extends StatefulWidget {
  const Settings(
      {Key? key,
      required this.user,
      required this.loggedIn,
      required this.logoutCallback,
      required this.themeCallback})
      : super(key: key);

  final String user;
  final bool loggedIn;
  final Function logoutCallback;
  final Function themeCallback;

  @override
  State<Settings> createState() => _SettingsState();
}

enum AppTheme { light, dark, system }

class _SettingsState extends State<Settings> {
  AppTheme _selectedTheme = AppTheme.dark;

  Future<void> _loadTheme() async {
    final theme = await Preferences.getTheme();
    widget.themeCallback(theme);

    setState(() {
      _selectedTheme = AppTheme.values[theme];
    });
  }

  Future<void> _saveTheme(int theme) async {
    await Preferences.setTheme(theme);
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const PageTitle(
          text: 'Settings',
        ),
        ListTile(
          title: Text(
            'Account',
            style: Theme.of(context).textTheme.headline2,
          ),
          subtitle: Text(
              widget.loggedIn
                  ? 'Logged in as ${widget.user}'
                  : 'Currently not logged in.',
              style: Theme.of(context).textTheme.headline3),
          leading: const Icon(
            Icons.account_circle_rounded,
          ),
          trailing: widget.loggedIn
              ? TextButton(
                  onPressed: () {
                    widget.logoutCallback();
                  },
                  child: Text(
                    'LOG OUT',
                    style: Theme.of(context).textTheme.button,
                  ),
                )
              : TextButton(
                  onPressed: () {},
                  child: Text(
                    'LOG IN',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: Text(
            'Theme',
            style: Theme.of(context).textTheme.headline2,
          ),
          subtitle: Text(
            'Change how the application looks',
            style: Theme.of(context).textTheme.headline3,
          ),
          leading: const Icon(
            Icons.color_lens_rounded,
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Select theme'),
                content: Wrap(
                  children: [
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Light',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          leading: Radio(
                              value: AppTheme.light,
                              groupValue: _selectedTheme,
                              onChanged: (AppTheme? value) {
                                setState(() {
                                  _selectedTheme = value!;
                                  _saveTheme(_selectedTheme.index);
                                  widget.themeCallback(_selectedTheme.index);
                                });
                              }),
                        ),
                        ListTile(
                          title: Text(
                            'Dark',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          leading: Radio(
                              value: AppTheme.dark,
                              groupValue: _selectedTheme,
                              onChanged: (AppTheme? value) {
                                setState(() {
                                  _selectedTheme = value!;
                                  _saveTheme(_selectedTheme.index);
                                  widget.themeCallback(_selectedTheme.index);
                                });
                              }),
                        ),
                        ListTile(
                          title: Text(
                            'System default',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          leading: Radio(
                              value: AppTheme.system,
                              groupValue: _selectedTheme,
                              onChanged: (AppTheme? value) {
                                setState(() {
                                  _selectedTheme = value!;
                                  _saveTheme(_selectedTheme.index);
                                  widget.themeCallback(_selectedTheme.index);
                                });
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
