import 'package:flutter/material.dart';
import 'package:msg/services/storage_service.dart';

ColorScheme _customColorSchemeLight = ColorScheme(
  primary: Colors.grey.withOpacity(0.20),
  secondary: Color.fromARGB(194, 215, 215, 215),
  tertiary: Color.fromARGB(181, 206, 206, 206),
  primaryContainer: Color.fromARGB(159, 184, 184, 184),
  surface: Colors.black,
  background: Colors.black,
  error: Colors.black,
  onPrimary: Colors.black,
  onSecondary: Colors.white,
  onSurface: Colors.black,
  onBackground: Colors.black,
  onError: Colors.black,
  brightness: Brightness.dark,
);

ColorScheme _customColorSchemeDark = ColorScheme(
  primary: Colors.grey.withOpacity(0.15),
  secondary: Color.fromARGB(194, 81, 81, 81),
  tertiary: Color.fromARGB(181, 94, 94, 94),
  primaryContainer: Color.fromARGB(159, 184, 184, 184),
  surface: Colors.grey,
  background: Colors.white,
  error: Colors.white,
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.white,
  onBackground: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;

  ThemeData light = ThemeData.light().copyWith(
    colorScheme: _customColorSchemeLight,
    textTheme: TextTheme(
      headline1: const TextStyle(
          fontSize: 26, color: Colors.black, fontWeight: FontWeight.normal),
      headline2: const TextStyle(
          fontSize: 24, color: Colors.black, fontWeight: FontWeight.normal),
      headline3: const TextStyle(
          fontSize: 22, color: Colors.black, fontWeight: FontWeight.normal),
      bodyText1: const TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal),
      bodyText2: const TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal),
      caption: TextStyle(
          fontSize: 20, color: Colors.grey[700], fontWeight: FontWeight.normal),
    ),
  );

  ThemeData dark = ThemeData.dark().copyWith(
    colorScheme: _customColorSchemeDark,
    textTheme: TextTheme(
      headline1: const TextStyle(
          fontSize: 24, color: Colors.white, fontWeight: FontWeight.normal),
      headline2: const TextStyle(
          fontSize: 22, color: Colors.white, fontWeight: FontWeight.normal),
      headline3: const TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.normal),
      bodyText1: const TextStyle(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
      bodyText2: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 219, 219, 219),
          fontWeight: FontWeight.normal),
      caption: TextStyle(
          fontSize: 20, color: Colors.grey[400], fontWeight: FontWeight.normal),
    ),
  );

  ThemeProvider({required bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  ThemeData get getTheme => _selectedTheme;

  void setTheme(bool theme) {
    if (theme == true) {
      _selectedTheme = dark;
    } else if (theme == false) {
      _selectedTheme = light;
    }

    if (_selectedTheme == dark) {
      StorageService.setAppThemeId(true);
    } else if (_selectedTheme == light) {
      StorageService.setAppThemeId(false);
    }

    notifyListeners();
  }
}
