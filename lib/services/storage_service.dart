import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _appThemeKey = 'theme';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      debugPrint('Initialized Storage');
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

    if (_prefs!.containsKey(_appThemeKey)) {
      return _prefs!.getBool(_appThemeKey);
    } else {
      _prefs!.setBool(_appThemeKey, false);
    }

    return _prefs!.getBool(_appThemeKey);
  }

  static void setAppThemeId(bool isDarkMode) {
    if (!_checkInitialized()) {
      return;
    }

    _prefs!.setBool(_appThemeKey, isDarkMode);
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
