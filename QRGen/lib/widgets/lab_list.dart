import 'package:flutter/material.dart';
import 'package:qrgen/widgets/lab_element.dart';
import 'package:qrgen/widgets/page_title.dart';

import '../classes/lab.dart';
import '../utils/communication.dart';
import '../utils/display.dart';
import '../utils/preferences.dart';

class LabList extends StatefulWidget {
  const LabList({Key? key}) : super(key: key);

  @override
  State<LabList> createState() => _LabListState();
}

class _LabListState extends State<LabList> {
  String _username = '';

  List<Lab> _labs = [];
  late Future<void> _initLabs;

  String _joinCode = '';

  Future<void> dummyFuture() async {}

  // QR CODES
  Future<void> _refreshLabs() async {
    try {
      final labs = await Communication.requestLabs();
      setState(() {
        _labs = labs;
      });
    } on Exception catch (e) {
      Display.showDismissibleSnackBar(context, e.toString());
    }
  }

  Future<void> _init() async {
    _initLabs = dummyFuture();

    final user = await Preferences.getUsername();

    setState(() {
      _username = user;
    });

    await _refreshLabs();
  }

  void showJoinDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Join Lab'),
            content: TextField(
              autofocus: true,
              onChanged: (String value) {
                _joinCode = value;
              },
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                  child: const Text('JOIN')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('CANCEL')),
            ],
          );
        }).then((result) async {
      if (result == null || !result) {
        return;
      }
      try {
        await Communication.joinLab(_joinCode);
        await _refreshLabs();
      } on Exception catch (e) {
        Display.showDismissibleSnackBar(context, e.toString());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final titleElement = PageTitle(text: 'Hello, $_username');

    return FutureBuilder(
        future: _initLabs,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              {
                return const Center(child: CircularProgressIndicator());
              }
            case ConnectionState.done:
              {
                return RefreshIndicator(
                  onRefresh: _refreshLabs,
                  child: _labs.isEmpty
                      ? Stack(
                          children: [
                            ListView(
                              children: [titleElement],
                            ),
                            FractionallySizedBox(
                              heightFactor: 0.5,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'No upcoming labs',
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              heightFactor: 0.6,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      height: 100,
                                    ),
                                    FloatingActionButton(
                                      onPressed: showJoinDialog,
                                      child: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              heightFactor: 0.53,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Tap to join a lab ...',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              heightFactor: 0.9,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.keyboard_double_arrow_down_rounded,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                    Text(
                                      '... or pull down to refresh',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: _labs.length + 5,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return titleElement;
                            }
                            if (index - 1 < _labs.length) {
                              return LabElement(element: _labs[index - 1], user: _username, refresh: () async { await _refreshLabs(); },);
                            }
                            if (index == _labs.length + 1 ||
                                index == _labs.length + 4) {
                              return const SizedBox(
                                height: 40,
                              );
                            }
                            if (index == _labs.length + 3) {
                              return Container(
                                margin: const EdgeInsets.all(16.0),
                                child: const Center(
                                  child: Text(
                                    'Tap to join a lab',
                                    style: TextStyle(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return FloatingActionButton(
                              onPressed: showJoinDialog,
                              child: const Icon(Icons.add),
                            );
                          }),
                );
              }
          }
        });
  }
}
