import 'package:flutter/material.dart';
import 'package:msg/views/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
        theme: ThemeData(fontFamily: 'PoppinsRegular'),
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}
