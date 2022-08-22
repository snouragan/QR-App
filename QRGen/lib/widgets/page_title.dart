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
        margin: const EdgeInsets.only(
          top: 60.0,
          bottom: 30.0,
          left: 32.0,
          right: 32.0,
        ),
        child: Text(
          widget.text,
          style: Theme.of(context).textTheme.headline6,
        ),
    );
  }
}
