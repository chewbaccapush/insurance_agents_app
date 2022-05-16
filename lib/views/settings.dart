import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  
  void switchValue() {
    debugPrint("hej");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("msg"),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            //titlePadding: EdgeInsets.all(20),
            title: Text("Osnovno"),
            tiles: [
              SettingsTile(
                title: Text('Jezik'),
                //subtitle: 'English',
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                initialValue: false,
                title: Text('Uporabi sistemsko temo'),
                leading: Icon(Icons.phone_android),
                // switch: isSwitched,
                onToggle: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
