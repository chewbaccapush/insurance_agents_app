import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>{
  Map<String, Object>? allEntries;

  // Get orders from users local storage
  void localGet() async{
    final instance = await SharedPreferences.getInstance();
    final keys = instance.getKeys();

    for(String key in keys) {
      allEntries![key] = instance.get(key)!;
    }
  
    print(allEntries);
  }
  
  @override
  Widget build(BuildContext context) {
    return const Text("History");
  }

}