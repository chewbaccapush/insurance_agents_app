import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _appThemeKey = 'theme';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      print('Initialized Storage');
    }
  }

  static bool? getAppThemeId() {
    if (!_checkInitialized()) {
      return null;
    }

    return _prefs!.getBool(_appThemeKey);
  }

  static Future<bool?> getAppTheme() async {
    if (!_checkInitialized()) {
      return null;
    }
    _prefs = await SharedPreferences.getInstance();

    if (_prefs!.containsKey(_appThemeKey)) {
      return _prefs!.getBool(_appThemeKey);
    } else {
      _prefs!.setBool(_appThemeKey, false);
    }

    return _prefs!.getBool(_appThemeKey);
  }

  static Future<void> setAppThemeId(bool isDarkMode) async {
    if (!_checkInitialized()) {
      print("Not initialized.");
      return;
    }

    print("DarkMODDEEE " + isDarkMode.toString());

    await _prefs!
        .setBool(_appThemeKey, isDarkMode)
        .then((value) => debugPrint("Storage updated."));
  }

  static bool _checkInitialized() {
    if (_prefs == null) {
      if (kDebugMode) {
        print(
            'Storage not initialized. Please make sure to run StorageProvider.init()');
      }
      return false;
    }
    return true;
  }
}
