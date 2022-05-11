import 'package:flutter/material.dart';
import 'package:msg/views/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  get bottomNavigationBar => null;

  @override
  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "End User Page",
        home: HomePage());
  }
}
