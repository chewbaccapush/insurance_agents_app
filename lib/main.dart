import 'package:flutter/material.dart';
import 'package:msg/screens/home.dart';
import 'package:msg/services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(ChangeNotifierProvider(
      child: const MyApp(),
      create: (BuildContext context) => ThemeProvider(isDarkMode: true),
    ));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
          theme: themeProvider.getTheme,
          debugShowCheckedModeBanner: false,
          home: const HomePage());
    });
  }
}
