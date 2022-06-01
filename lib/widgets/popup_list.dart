import 'dart:js';

import 'package:flutter/material.dart';
import 'package:msg/models/Measurement/measurement.dart';

class PopupList extends StatelessWidget {
  PopupList({
    Key? key,
    required this.elements,
    required this.title
  }) : super(key: key);

  final List<Measurement> elements;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        ListView.builder(
        itemBuilder: (BuildContext context, int i) {
          String? name = elements[i].description;
          return ListTile(
            title: Text('$name'),
          );
        },
        itemCount: elements.length,
        ),
      TextButton(
            onPressed: () {
            Navigator.of(context).pop();
            }, 
            child: Text("Close"))
      ],
    );
  } 
}