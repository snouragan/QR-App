import 'package:flutter/material.dart';

class LabList extends StatefulWidget {
  const LabList({Key? key}) : super(key: key);

  @override
  State<LabList> createState() => _LabListState();
}

class _LabListState extends State<LabList> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('LabView', style: TextStyle(fontSize: 40.0)));
  }
}
