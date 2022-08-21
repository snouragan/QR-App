import 'package:flutter/material.dart';
import 'package:qrgen/classes/lab.dart';
import 'package:qrgen/utils/display.dart';

import '../utils/communication.dart';

class LabElement extends StatefulWidget {
  const LabElement({Key? key, required this.element}) : super(key: key);

  final Lab element;

  @override
  State<LabElement> createState() => _LabElementState();
}

class _LabElementState extends State<LabElement> {
  late Lab _lab;

  final _textStyle = const TextStyle(fontSize: 24.0);

  String parseDate(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;
    final hour = date.hour;
    final minute = date.minute < 10 ? '0${date.minute}' : date.minute;

    return '$hour:$minute';
  }

  List<Widget> generateParticipantList(Function update) {
    final List<Widget> participants = [];

    for (int i = 0; i < _lab.participants.length; i++) {
      participants.add(Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _lab.participants[i],
              style: const TextStyle(fontSize: 20.0),
            ),
            const Spacer(),
            TextButton(
                onPressed: () async {
                  try {
                    Lab newLab = await Communication.kickParticipant(_lab, i);
                    update(() {
                      _lab = newLab;
                    });
                  } on Exception catch (e) {
                    Display.showDismissibleSnackBar(context, e.toString());
                  }
                },
                child: const Text('KICK')),
          ],
        ),
      ));
    }

    return participants;
  }

  @override
  void initState() {
    super.initState();
    _lab = widget.element;
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
      fontSize: 18.0,
    );
    return Container(
      height: 150,
      margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: const Color(0xff1c1c1c),
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter update) {
                  return Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        padding: const EdgeInsets.only(
                            left: 32.0, right: 32.0, top: 8.0, bottom: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xff1c1c1c),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 50,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              _lab.name,
                              style: const TextStyle(fontSize: 40.0),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            ListTile(
                              leading: const Icon(Icons.access_time_rounded),
                              title: const Text(
                                'Date',
                                style: TextStyle(fontSize: 28.0),
                              ),
                              subtitle: Text(
                                '${parseDate(_lab.start)} - ${parseDate(_lab.end)}',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              leading: const Icon(Icons.lock),
                              title: const Text(
                                'Owner',
                                style: TextStyle(fontSize: 28.0),
                              ),
                              subtitle: Text(
                                _lab.owner,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ExpansionTile(
                              leading: const Icon(Icons.account_circle_rounded),
                              title: const Text(
                                'Participants',
                                style: TextStyle(fontSize: 28.0),
                              ),
                              subtitle: Text(
                                '${_lab.participants.length} user${_lab.participants.length == 1 ? '' : 's'}',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white70,
                                ),
                              ),
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  height: 400,
                                  child: ListView(
                                    children: generateParticipantList(update),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                });
              });
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  height: 100,
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.only(right: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Icon(
                    Icons.science_rounded,
                    color: Colors.white,
                    size: 100,
                  )),
              Text(
                _lab.name,
                style: const TextStyle(fontSize: 40.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
