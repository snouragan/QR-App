import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  bool _showQR = false;

  String getParticipantCountString() {
    int count = _lab.participants.length;
    if (_lab.owner == widget.user) {
      count = _lab.participants.length + _lab.pending.length;
    }

    return '$count user${count == 1 ? '' : 's'}${_lab.owner == widget.user && _lab.pending.isNotEmpty ? ', ${_lab.pending.length} pending' : ''}';
  }

  List<Widget> generateParticipantList() {
    final List<Widget> participants = [];

    if (_lab.owner == widget.user) {
      if (_lab.pending.isNotEmpty) {
        participants.add(Container(
          margin: const EdgeInsets.all(8.0),
          child: Text(
            'Pending:',
            style: Theme.of(context).textTheme.headline3,
          ),
        ));
      }

      for (int i = 0; i < _lab.pending.length; i++) {
        participants.add(Container(
          height: 64,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.surfaceTintColor,
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
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  try {
                    Lab newLab = await Communication.managePending(
                        _lab, _lab.pending[i], true);
                    setState(() {
                      _lab = newLab;
                      widget.refresh();
                    });
                  } on Exception catch (e) {
                    Display.showDismissibleSnackBar(context, e.toString());
                  }
                },
                child: Text(
                  'ACCEPT',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    Lab newLab = await Communication.managePending(
                        _lab, _lab.pending[i], false);
                    setState(() {
                      _lab = newLab;
                      widget.refresh();
                    });
                  } on Exception catch (e) {
                    Display.showDismissibleSnackBar(context, e.toString());
                  }
                },
                child: Text(
                  'REJECT',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ));
      }

      if (_lab.participants.isNotEmpty && _lab.pending.isNotEmpty) {
        participants.add(Container(
          margin: const EdgeInsets.all(8.0),
          child: Text(
            'Participants:',
            style: Theme.of(context).textTheme.headline3,
          ),
        ));
      }
    }

    for (int i = 0; i < _lab.participants.length; i++) {
      participants.add(Container(
        height: 64,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.surfaceTintColor,
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
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const Spacer(),
            _lab.owner == widget.user
                ? TextButton(
                    onPressed: () async {
                      try {
                        Lab newLab = await Communication.kickParticipant(
                            _lab, _lab.participants[i]);
                        setState(() {
                          _lab = newLab;
                          widget.refresh();
                        });
                      } on Exception catch (e) {
                        Display.showDismissibleSnackBar(context, e.toString());
                      }
                    },
                    child: Text(
                      'KICK',
                      style: Theme.of(context).textTheme.button,
                    ),
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
    return Wrap(
      children: [
        Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 8.0,
            bottom: 16.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).cardTheme.color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 50,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    _lab.name,
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.start,
                  ),
                  const Spacer(),
                  ...(_lab.qr != -1
                      ? [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showQR = !_showQR;
                              });
                            },
                            child: Icon(_showQR
                                ? Icons.info_outline_rounded
                                : Icons.qr_code),
                          ),
                        ]
                      : [])
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              ...(_showQR
                  ? [
                      Center(
                        child: QrImage(
                          data: '${_lab.qr}',
                          version: 1,
                          size: 300,
                          foregroundColor:
                              Theme.of(context).textTheme.headline1?.color,
                        ),
                      ),
                    ]
                  : [
                      ListTile(
                        leading: const Icon(Icons.key),
                        title: Text(
                          'Join Code',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        subtitle: Text(
                          _lab.code,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: const Icon(Icons.access_time_rounded),
                        title: Text(
                          'Date',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        subtitle: Text(
                          Display.parseDate(_lab.start, _lab.end),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: Text(
                          'Owner',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        subtitle: Text(
                          '${_lab.owner}${_lab.owner == widget.user ? ' (you)' : ''}',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ExpansionTile(
                        leading: const Icon(Icons.account_circle_rounded),
                        title: Text(
                          'Participants',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        subtitle: Text(
                          getParticipantCountString(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 400,
                            child: ListView(
                              children: generateParticipantList(),
                            ),
                          ),
                        ],
                      ),
                    ])
            ],
          ),
        )
      ],
    );
  }
}
