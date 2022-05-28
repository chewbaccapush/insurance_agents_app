import 'package:flutter/material.dart';
import 'package:msg/services/storage_service.dart';

const ColorScheme _customColorSchemeLight = ColorScheme(
  primary: Color.fromARGB(255, 154, 52, 86),
  secondary: Color.fromARGB(255, 138, 47, 79),
  tertiary: Color.fromARGB(255, 134, 37, 71),
  primaryContainer: Color.fromARGB(159, 184, 184, 184),
  surface: Colors.black,
  background: Colors.black,
  error: Colors.black,
  onPrimary: Colors.black,
  onSecondary: Colors.white,
  onSurface: Colors.black,
  onBackground: Colors.black,
  onError: Colors.black,
  brightness: Brightness.light,
);

const ColorScheme _customColorSchemeDark = ColorScheme(
  primary: Color.fromARGB(148, 112, 14, 46),
  secondary: Color.fromARGB(110, 122, 16, 51),
  tertiary: Color.fromARGB(97, 142, 18, 57),
  primaryContainer: Colors.grey,
  surface: Colors.grey,
  background: Colors.white,
  error: Colors.white,
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.white,
  onBackground: Colors.white,
  onError: Colors.white,
  brightness: Brightness.light,
);

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;

  ThemeData light = ThemeData.light().copyWith(
      scaffoldBackgroundColor: Color.fromARGB(255, 238, 238, 238),
      colorScheme: _customColorSchemeLight,
      textTheme: TextTheme(
        headline1: const TextStyle(
            fontSize: 26, color: Colors.white, fontWeight: FontWeight.normal),
        headline2: const TextStyle(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.normal),
        headline3: const TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.normal),
        bodyText1: const TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
        bodyText2: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
        caption: TextStyle(
            fontSize: 20,
            color: Colors.grey[700],
            fontWeight: FontWeight.normal),
      ));

  ThemeData dark = ThemeData.dark().copyWith(
      colorScheme: _customColorSchemeDark,
      textTheme: TextTheme(
        headline1: const TextStyle(
            fontSize: 26, color: Colors.white, fontWeight: FontWeight.normal),
        headline2: const TextStyle(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.normal),
        headline3: const TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.normal),
        bodyText1: const TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
        bodyText2: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 219, 219, 219),
            fontWeight: FontWeight.normal),
        caption: TextStyle(
            fontSize: 20,
            color: Colors.grey[400],
            fontWeight: FontWeight.normal),
      ));

  ThemeProvider({required bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  ThemeData get getTheme => _selectedTheme;

  void swapTheme() {
    _selectedTheme = _selectedTheme == dark ? light : dark;

    if (_selectedTheme == dark) {
      StorageService.setAppThemeId(true);
    } else if (_selectedTheme == light) {
      StorageService.setAppThemeId(false);
    }

    notifyListeners();
  }
}
