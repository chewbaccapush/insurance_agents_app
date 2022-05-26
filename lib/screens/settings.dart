import 'package:flutter/material.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../widgets/custom_navbar.dart';

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
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            const CustomNavbar(
              leading: Text("Settings"),
              firstIcon: Icon(Icons.send),
              secondIcon: Icon(Icons.history),
              firstDestination: BuildingAssessmentForm(),
              secondDestination: HistoryPage(),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Row(
              children: [
                Column(
                  children: [
                    ElevatedButton.icon(
                      label: Text('Theme',
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onSecondary)),
                      icon: Icon(
                        Icons.dark_mode,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      onPressed: () {
                        ThemeProvider themeProvider =
                            Provider.of(context, listen: false);
                        themeProvider.swapTheme();
                      },
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildSettings() {
    return SizedBox.expand(
      child: ListView(children: [
        buildSwitchTile("Temna tema", Icon(Icons.dark_mode)),
        buildNavigationTile("Spremeni Jezik", Icon(Icons.language))
      ]),
    );
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
