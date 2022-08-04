import 'package:flutter/material.dart';
import 'package:qrgen/views/add_view.dart';
import 'package:qrgen/widgets/qr_list.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Map<String, String> codes = {};

  void _addCode(String name, String code) {
    setState(() {
      codes[code] = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRGen'),
      ),
      body: QRList(codes: codes),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddView(addCode: _addCode)));
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}
