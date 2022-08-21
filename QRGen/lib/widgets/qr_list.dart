import 'package:flutter/material.dart';
import 'package:qrgen/classes/qrcode.dart';
import 'package:qrgen/utils/communication.dart';
import 'package:qrgen/utils/display.dart';
import 'package:qrgen/utils/preferences.dart';
import 'package:qrgen/widgets/page_title.dart';
import 'package:qrgen/widgets/qr_element.dart';

class QRList extends StatefulWidget {
  const QRList({Key? key}) : super(key: key);

  @override
  State<QRList> createState() => _QRListState();
}

class _QRListState extends State<QRList> {
  String _username = '';

  List<QRCode> _codes = [];
  late Future<void> _initCodes;

  Future<void> dummyFuture() async {}

  // QR CODES
  Future<void> _refreshCodes() async {
    try {
      final cds = await Communication.requestCodes();
      setState(() {
        _codes = cds;
      });
    } on Exception catch (e) {
      Display.showDismissibleSnackBar(context, e.toString());
    }
  }

  Future<void> _init() async {
    _initCodes = dummyFuture();

    final user = await Preferences.getUsername();

    setState(() {
      _username = user;
    });

    await _refreshCodes();
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
        future: _initCodes,
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
                    onRefresh: _refreshCodes,
                    child: _codes.isEmpty
                        ? Stack(
                            children: [
                              ListView(
                                children: [titleElement],
                              ),
                              FractionallySizedBox(
                                heightFactor: 0.8,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons
                                            .keyboard_double_arrow_down_rounded,
                                        color: Colors.white54,
                                        size: 20,
                                      ),
                                      Text(
                                        'Pull down to refresh',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              FractionallySizedBox(
                                heightFactor: 0.5,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'No codes for now',
                                        style: TextStyle(
                                            fontSize: 40.0,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              FractionallySizedBox(
                                heightFactor: 0.98,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Check for upcoming labs here',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white54,
                                        ),
                                      ),
                                      Icon(Icons.keyboard_arrow_down_rounded,
                                          color: Colors.white54, size: 20)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : ListView(children: [
                            titleElement,
                            ..._codes.map((c) {
                              return QRElement(element: c);
                            }).toList(),
                          ]));
              }
          }
        });
  }
}
