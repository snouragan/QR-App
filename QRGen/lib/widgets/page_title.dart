import 'package:flutter/material.dart';

class PageTitle extends StatefulWidget {
  const PageTitle({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  State<PageTitle> createState() => _PageTitleState();
}

class _PageTitleState extends State<PageTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 30.0, bottom: 30.0, left: 16.0, right: 16.0),
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: 50.0),
        ));
  }
}
