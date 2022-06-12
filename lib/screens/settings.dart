import 'package:flutter/material.dart';
import 'package:msg/main.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/screens/login.dart';
import 'package:msg/screens/pin.dart';
import 'package:msg/services/navigator_service.dart';
import 'package:msg/services/storage_service.dart';
import 'package:msg/services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets/custom_navbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool? _darkMode = StorageService.getAppThemeId();
  dynamic _currentLanguage = StorageService.getLocale()!.languageCode;

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
                        AppLocalizations.of(context)!.settings_heading,
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
                        AppLocalizations.of(context)!.settings_darkMode,
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
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    if (_currentLanguage == "en") {
                      MyApp.setLocale(context, const Locale("de", "DE"));
                      setState(() {
                        _currentLanguage = "de";
                      });
                    } else if (_currentLanguage == "de") {
                      MyApp.setLocale(context, const Locale("en", "EN"));
                      setState(() {
                        _currentLanguage = "en";
                      });
                    }
                  });
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
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(Icons.language_outlined,
                                          size: 18),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .settings_language,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: _currentLanguage == "en"
                                            ? const EdgeInsets.only(left: 0)
                                            : const EdgeInsets.only(left: 17.5),
                                        child: Text(
                                          _currentLanguage == "en"
                                              ? "English"
                                              : "Deutsch",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[400]),
                                        ),
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

            // ---- Change pin ----

            InkWell(
                onTap: () {
                  NavigatorService.navigateTo(
                      context, PinPage(changingPin: true));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.key, size: 18),
                          ),
                          Text(
                            AppLocalizations.of(context)!.change_pin,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  ),
                )),

            // ---- Logout ----

            InkWell(
                onTap: () {
                  StorageService.setLoggedIn(false);
                  NavigatorService.navigateTo(context, LoginPage());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.logout, size: 18),
                          ),
                          Text(
                            AppLocalizations.of(context)!.log_out,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
