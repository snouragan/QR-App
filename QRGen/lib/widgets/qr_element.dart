import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRElement extends StatefulWidget {
  const QRElement({Key? key, required this.text, r, required this.code})
      : super(key: key);

  final String text;
  final String code;

  @override
  State<QRElement> createState() => _QRElementState();
}

class _QRElementState extends State<QRElement> {
  final _textStyle = const TextStyle(fontSize: 24.0);

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
                    height: 480,
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(64.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 240,
                          padding: const EdgeInsets.all(4.0),
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: QrImage(
                            data: widget.code,
                            version: 1,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 32.0),
                            child: Text(widget.code, style: const TextStyle(fontSize: 14.0))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {},
                                color: Colors.white,
                                icon: const Icon(Icons.edit, size: 50.0)),
                            const SizedBox(width: 50),
                            IconButton(
                                onPressed: () {},
                                color: Colors.white,
                                icon: const Icon(Icons.delete_rounded,
                                    size: 50.0)),
                          ],
                        )
                      ],
                    ));
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
                  data: widget.code,
                  version: 1,
                ),
              ),
              Text(
                widget.text,
                style: _textStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
