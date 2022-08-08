import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrgen/classes/qrcode.dart';

class QRElement extends StatefulWidget {
  const QRElement({Key? key, required this.element}) : super(key: key);

  final QRCode element;

  @override
  State<QRElement> createState() => _QRElementState();
}

class _QRElementState extends State<QRElement> {
  final _textStyle = const TextStyle(fontSize: 24.0);

  String parseDate(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;
    final hour = date.hour;
    final minute = date.minute < 10 ? '0${date.minute}' : date.minute;

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black45,
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: QrImage(
                      data: widget.element.code,
                      version: 1,
                    ),
                  ),
                );
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
                child: QrImage(
                  foregroundColor: Colors.white,
                  data: widget.element.code,
                  version: 1,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.element.text,
                    style: _textStyle,
                  ),
                  Text(
                    '${parseDate(widget.element.start)} - ${parseDate(widget.element.end)}',
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
