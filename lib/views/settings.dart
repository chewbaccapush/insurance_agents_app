import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

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
    return SettingsList(
      sections: [
        SettingsSection(
          tiles: <SettingsTile>[
            buildNavigationTile("Jezik", Icon(Icons.language)),
            buildSwitchTile("Temna tema", Icon(Icons.dark_mode))
          ],
        ),
      ],
    );
  }

  SettingsTile buildSwitchTile(title, icon) {
    return SettingsTile.switchTile(
      title: Text(title),
      leading: icon,
      initialValue: _darkMode,
      onToggle: (value) {
        setState(() {
          _darkMode = value;
        });
      },
    );
  }

  SettingsTile buildNavigationTile(title, icon) {
    return SettingsTile.navigation(
      title: Text(title),
      leading: icon,
      value: Text(_currentLanguage),
      onPressed: (BuildContext context) {},
    );
  }
}
