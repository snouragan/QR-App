import 'package:flutter/material.dart';
import 'package:qrgen/classes/lab.dart';
import 'package:qrgen/widgets/lab_details.dart';

class LabElement extends StatefulWidget {
  const LabElement(
      {Key? key,
      required this.element,
      required this.user,
      required this.refresh})
      : super(key: key);

  final Lab element;
  final String user;
  final Function refresh;

  @override
  State<LabElement> createState() => _LabElementState();
}

class _LabElementState extends State<LabElement> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Theme.of(context).cardTheme.color,
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return LabDetails(
                  lab: widget.element,
                  user: widget.user,
                  refresh: widget.refresh,
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
                  child: const Icon(
                    Icons.qr_code,
                    size: 100,
                  )),
              Text(
                widget.element.name,
                style: Theme.of(context).textTheme.headline1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
