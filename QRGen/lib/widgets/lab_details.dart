import 'package:flutter/material.dart';
import 'package:qrgen/classes/lab.dart';

import '../utils/communication.dart';
import '../utils/display.dart';

class LabDetails extends StatefulWidget {
  const LabDetails(
      {Key? key, required this.lab, required this.user, required this.refresh})
      : super(key: key);

  final Lab lab;
  final String user;
  final Function refresh;

  @override
  State<LabDetails> createState() => _LabDetailsState();
}

class _LabDetailsState extends State<LabDetails> {
  late Lab _lab;

  String getParticipantCountString() {
    int count = _lab.participants.length;
    if (_lab.owner == widget.user) {
      count = _lab.participants.length + _lab.pending.length;
    }

    return '$count user${count == 1 ? '' : 's'}${_lab.owner == widget.user && _lab.pending.isNotEmpty ? ', ${_lab.pending.length} pending' : ''}';
  }

  List<Widget> generateParticipantList(Function update) {
    final List<Widget> participants = [];

    if (_lab.owner == widget.user) {
      if (_lab.pending.isNotEmpty) {
        participants.add(Container(
          margin: const EdgeInsets.all(8.0),
          child: const Text(
            'Pending',
            style: TextStyle(fontSize: 20.0),
          ),
        ));
      }

      for (int i = 0; i < _lab.pending.length; i++) {
        participants.add(Container(
          height: 64,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(i == 0 ? 10.0 : 0.0),
              topRight: Radius.circular(i == 0 ? 10.0 : 0.0),
              bottomLeft:
                  Radius.circular(i == _lab.pending.length - 1 ? 10.0 : 0.0),
              bottomRight:
                  Radius.circular(i == _lab.pending.length - 1 ? 10.0 : 0.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _lab.pending[i],
                style: const TextStyle(fontSize: 20.0),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  try {
                    Lab newLab = await Communication.managePending(
                        _lab, _lab.pending[i], true);
                    update(() {
                      _lab = newLab;
                      widget.refresh();
                    });
                  } on Exception catch (e) {
                    Display.showDismissibleSnackBar(context, e.toString());
                  }
                },
                child: const Text('ACCEPT'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    Lab newLab = await Communication.managePending(
                        _lab, _lab.pending[i], false);
                    update(() {
                      _lab = newLab;
                      widget.refresh();
                    });
                  } on Exception catch (e) {
                    Display.showDismissibleSnackBar(context, e.toString());
                  }
                },
                child: const Text('REJECT'),
              ),
            ],
          ),
        ));
      }

      if (_lab.participants.isNotEmpty && _lab.pending.isNotEmpty) {
        participants.add(Container(
          margin: const EdgeInsets.all(8.0),
          child: const Text(
            'Participants',
            style: TextStyle(fontSize: 20.0),
          ),
        ));
      }
    }

    for (int i = 0; i < _lab.participants.length; i++) {
      participants.add(Container(
        height: 64,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(i == 0 ? 10.0 : 0.0),
            topRight: Radius.circular(i == 0 ? 10.0 : 0.0),
            bottomLeft:
                Radius.circular(i == _lab.participants.length - 1 ? 10.0 : 0.0),
            bottomRight:
                Radius.circular(i == _lab.participants.length - 1 ? 10.0 : 0.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${_lab.participants[i]}${_lab.participants[i] == widget.user ? ' (you)' : ''}',
              style: const TextStyle(fontSize: 20.0),
            ),
            const Spacer(),
            _lab.owner == widget.user
                ? TextButton(
                    onPressed: () async {
                      try {
                        Lab newLab = await Communication.kickParticipant(
                            _lab, _lab.participants[i]);
                        update(() {
                          _lab = newLab;
                          widget.refresh();
                        });
                      } on Exception catch (e) {
                        Display.showDismissibleSnackBar(context, e.toString());
                      }
                    },
                    child: const Text('KICK'),
                  )
                : const Spacer(),
          ],
        ),
      ));
    }

    return participants;
  }

  @override
  void initState() {
    super.initState();
    _lab = widget.lab;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter update) {
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
                    '${Display.parseDate(_lab.start)} - ${Display.parseDate(_lab.end)}',
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
                    '${_lab.owner}${_lab.owner == widget.user ? ' (you)' : ''}',
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
                    getParticipantCountString(),
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
  }
}
