import 'package:flutter/material.dart';

class AddView extends StatefulWidget {
  final Function addCode;

  const AddView({Key? key, required this.addCode}) : super(key: key);

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  String qrName = '';
  String qrCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add QR code'),
        ),
        body: Container(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              TextField(
                // controller: TextEditingController(),
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (String name) {
                  qrName = name;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Code',
                ),
                onChanged: (String code) {
                  qrCode = code;
                },
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.addCode(qrName, qrCode);
                  },
                  child: const Text('Add')),
            ],
          ),
        ));
  }
}
