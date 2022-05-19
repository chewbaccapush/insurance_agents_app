import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
//import 'package:msg/styles/theme_data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  dynamic _currentLanguage = "Slovenian";

  dynamic changeTheme = (value) => {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nastavitve"),
        ),
        body: buildSettings());
  }

  Widget buildSettings() {
    return ListView(children: [
      buildSwitchTile("Temna tema", Icon(Icons.dark_mode)),
      buildNavigationTile("Spremeni Jezik", Icon(Icons.language))
    ]);
  }

  ListTile buildSwitchTile(title, icon) {
    return ListTile(
        leading: icon,
        title: Text(title),
        trailing: Switch(
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            }));
  }

  ListTile buildNavigationTile(title, icon) {
    return ListTile(
      leading: icon,
      title: Text(title),
      trailing: const Icon(Icons.keyboard_arrow_right),
    );
  }
}
