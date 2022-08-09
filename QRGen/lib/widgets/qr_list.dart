import 'package:flutter/material.dart';
import 'package:qrgen/classes/qrcode.dart';
import 'package:qrgen/widgets/qr_element.dart';

class QRList extends StatefulWidget {
  const QRList({Key? key, required this.codes}) : super(key: key);

  final List<QRCode> codes;

  @override
  State<QRList> createState() => _QRListState();
}

class _QRListState extends State<QRList> {
  List<Widget> _items = [];

  @override
  Widget build(BuildContext context) {
    if (widget.codes.isEmpty) {
      return Stack(
        children: [
          ListView(
            children: const [],
          ),
          FractionallySizedBox(
            heightFactor: 0.8,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'No codes for now',
                    style: TextStyle(fontSize: 40.0, color: Colors.white70),
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
      );
    }

    _items = widget.codes.map((c) {
      return QRElement(element: c);
    }).toList();

    return ListView(children: [..._items, Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        SizedBox(
          height: 20,
        ),
        Icon(
          Icons.keyboard_double_arrow_down_rounded,
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
    )]);
  }
}
