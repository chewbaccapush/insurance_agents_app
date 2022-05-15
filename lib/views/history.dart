import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:msg/models/proprety_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}


class _HistoryPageState extends State<HistoryPage>{
  List<dynamic> allEntries = [];

  @override
  void initState() {
    _localGet();
    super.initState();
  }

  // Get orders from users local storage
  _localGet() async {
    final instance = await SharedPreferences.getInstance();
    final keys = instance.getKeys();

    for (String key in keys) {
      allEntries.add(instance.get(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildView();
  }

  Widget buildView() {
    return ListView.separated(
        itemCount: allEntries.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, i) {
          dynamic entry = jsonDecode(allEntries[i]);
          return buildTile(entry);
        });
  }

  Widget buildTile(entry) {
    return ListTile(title: Text(entry["name"]), trailing: Text(entry["area"]));
  }


}
