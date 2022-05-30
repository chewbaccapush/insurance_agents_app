import 'package:flutter/material.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/services/storage_service.dart';
import 'package:msg/services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../widgets/custom_navbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool? _darkMode = StorageService.getAppThemeId();
  dynamic _currentLanguage = "English";

  dynamic changeTheme = (value) => {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50, top: 30),
        child: Column(
          children: [
            Row(
              children: [
                CustomNavbar(
                  leading: Row(
                    children: [
                      IconButton(
                        onPressed: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) => const HistoryPage()),
                            ),
                          )
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(Icons.dark_mode, size: 18),
                      ),
                      Text(
                        'Dark Mode',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      FlutterSwitch(
                        activeColor: Color.fromARGB(148, 112, 14, 46),
                        width: 60,
                        height: 30,
                        valueFontSize: 12,
                        toggleSize: 20,
                        value: _darkMode!,
                        borderRadius: 30,
                        padding: 6.0,
                        showOnOff: false,
                        onToggle: (val) {
                          setState(() {
                            _darkMode = val;
                          });
                          ThemeProvider themeProvider =
                              Provider.of(context, listen: false);
                          themeProvider.setTheme(val);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            InkWell(
                onTap: () {
                  print("Swap language");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(Icons.language_outlined,
                                          size: 18),
                                    ),
                                    Text(
                                      'Language',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        _currentLanguage,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[400]),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),

            /* Row(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(148, 112, 14, 46)),
                          label: Text('Theme',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
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
            )*/
          ],
        ),
      ),
    );
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
            value: _darkMode!,
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
