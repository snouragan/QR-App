import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:qrgen/views/add_view.dart';
import 'package:qrgen/widgets/qr_list.dart';

import '../classes/qrcode.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<QRCode> _codes = [];
  late Future<void> _initCodes;

  void _addCode(String text, String code) {
    setState(() async {
      final start = DateTime.now();
      final local = start.toLocal();
      final end = DateTime(local.year, local.month, local.day, local.hour + 2,
          local.minute, 0, 0, 0);

      final qr = QRCode(text: text, code: code, start: start, end: end);
      print('adding code ${jsonEncode(qr)}');
      final response = await http.post(Uri.parse('http://10.0.2.2:3000/codes'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: jsonEncode(qr));

      if (response.statusCode == 204) {
        refreshCodes();
      } else {
        throw Exception('Failed to add code');
      }
    });
  }

  Future<void> refreshCodes() async {
    print('refreshing...');
    final cds = await fetchCodes();
    setState(() {
      _codes = cds;
    });
  }

  Future<List<QRCode>> fetchCodes() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/codes'));

    if (response.statusCode == 200) {
      final List<dynamic> codeList = jsonDecode(response.body);
      print('fetched $codeList');
      return codeList.map((c) => QRCode.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load codes');
    }
  }

  @override
  void initState() {
    super.initState();
    _initCodes = refreshCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Codes'),
      ),
      body: FutureBuilder(
          future: _initCodes,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                {
                  return const CircularProgressIndicator();
                }
              case ConnectionState.done:
                {
                  return RefreshIndicator(
                      onRefresh: refreshCodes, child: QRList(codes: _codes));
                }
            }
          }),
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
