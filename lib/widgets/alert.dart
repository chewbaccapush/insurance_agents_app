import 'package:flutter/material.dart';
import 'dart:ui';

class Alert extends StatelessWidget {
  const Alert({Key? key, required this.title, required this.content}) : super(key: key);
  
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
            Navigator.of(context).pop();
            }, 
            child: Text("Close"))
        ],
      ),
    );
  }
}