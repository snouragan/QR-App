import 'package:flutter/material.dart';
import 'package:qrgen/widgets/qr_element.dart';

class QRList extends StatefulWidget {
  const QRList({Key? key, required this.codes}) : super(key: key);

  final Map<String, String> codes;

  @override
  State<QRList> createState() => _QRListState();
}

class _QRListState extends State<QRList> {

  List<Widget> _items = [];

  @override
  Widget build(BuildContext context) {
    _items = widget.codes.entries.map((e) {
      return QRElement(text: e.value, code: e.key);
    }).toList();

    return ListView(children: _items);
  }
}
