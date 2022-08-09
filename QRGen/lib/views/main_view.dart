import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'package:qrgen/widgets/lab_list.dart';
import 'package:qrgen/widgets/settings.dart';
import 'package:qrgen/widgets/qr_list.dart';

import '../classes/qrcode.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String _user = 'user';

  int _viewIndex = 0;

  List<QRCode> _codes = [];
  late Future<void> _initCodes;

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = (prefs.getString('user') ?? 'user');
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', 'janelu44');
  }

  Future<void> refreshCodes() async {
    final cds = await fetchCodes();
    setState(() {
      _codes = cds;
    });
  }

  Future<List<QRCode>> fetchCodes() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/codes'));

    if (response.statusCode == 200) {
      final List<dynamic> codeList = jsonDecode(response.body);
      return codeList.map((c) => QRCode.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load codes');
    }
  }

  void _navBarTap(int index) {
    setState(() {
      _viewIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initCodes = refreshCodes();

    // _savePreferences();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _viewIndex == 0
                      ? 'Hello, $_user'
                      : _viewIndex == 1
                          ? 'My Labs'
                          : 'Settings',
                  style: const TextStyle(fontSize: 50.0),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _viewIndex == 0
          ? FutureBuilder(
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
                          onRefresh: refreshCodes,
                          child: QRList(codes: _codes));
                    }
                }
              })
          : _viewIndex == 1
              ? const LabList()
              : const Settings(),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code, size: 40), label: 'Codes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month, size: 40), label: 'Labs'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 40,
              ),
              label: 'Settings'),
        ],
        currentIndex: _viewIndex,
        onTap: _navBarTap,
      ),
    );
  }
}
