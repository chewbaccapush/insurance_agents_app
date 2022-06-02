import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _appThemeKey = 'theme';
  static const String _appLanguageKey = 'languageCode';
  static const String _appCountryKey = 'countryCode';
  static const String _loggedIn = 'loggedIn';
  static const String _pinCode = 'pinCode';

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

  static Locale? getLocale() {
    if (!_checkInitialized()) {
      return null;
    }

    String languageCode = _prefs!.getString(_appLanguageKey) ?? 'en';
    String countryCode = _prefs!.getString(_appCountryKey) ?? 'EN';

    return Locale(languageCode, countryCode);
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

  static void setLocale(String languageKey, String countryKey) {
    if (!_checkInitialized()) {
      return;
    }

    _prefs!.setString(_appLanguageKey, languageKey);
    _prefs!.setString(_appCountryKey, countryKey);
  }

  static bool? isLoggedIn() {
    if (!_checkInitialized()) {
      return null;
    }

    if (_prefs!.containsKey(_loggedIn)) {
      return _prefs!.getBool(_loggedIn);
    } else {
      _prefs!.setBool(_loggedIn, false);
      return _prefs!.getBool(_loggedIn);
    }
  }

  static void setLoggedIn(bool value) {
    if (!_checkInitialized()) {
      return;
    }

    _prefs!.setBool(_loggedIn, value);
  }

  static String? getPinCode() {
    if (!_checkInitialized()) {
      return null;
    }

    if (_prefs!.containsKey(_pinCode)) {
      return _prefs!.getString(_pinCode);
    } else {
      _prefs!.setString(_loggedIn, '0000');
      return _prefs!.getString(_loggedIn);
    }
  }

  static void setPinCode(String pinCode) {
     if (!_checkInitialized()) {
      return;
    }
    _prefs!.setString(_pinCode, pinCode);
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
