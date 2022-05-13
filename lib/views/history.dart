import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:msg/models/proprety_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>{
  List<dynamic> allEntries = [];
  
  @override
  void initState() {
    super.initState();
    localGet();
  }

  // Get orders from users local storage
  void localGet() async{
    final instance = await SharedPreferences.getInstance();
    final keys = instance.getKeys();
    print(keys);

    for(String key in keys) {
      print(instance.get(key));
      allEntries.add(instance.get(key)); 
    }
  
    print(allEntries);
  }
  
  @override
  Widget build(BuildContext context) {
    return const Text("History");
  }

}