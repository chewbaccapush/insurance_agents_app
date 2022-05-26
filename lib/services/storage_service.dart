import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _appThemeKey = 'app_theme';

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

    return bool.fromEnvironment(_prefs!.getString(_appThemeKey)!);
  }

  static Future<void> setAppThemeId(bool isDarkMode) async {
    if (!_checkInitialized()) {
      return;
    }

    await _prefs!.setString(_appThemeKey, isDarkMode.toString());
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
