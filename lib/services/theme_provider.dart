import 'package:flutter/material.dart';
import 'package:msg/services/storage_service.dart';

const ColorScheme _customColorSchemeLight = ColorScheme(
  primary: Color.fromARGB(241, 158, 48, 85),
  secondary: Color.fromARGB(255, 151, 38, 76),
  tertiary: Color.fromARGB(255, 142, 31, 67),
  primaryContainer: Color.fromARGB(159, 184, 184, 184),
  surface: Colors.black,
  background: Colors.black,
  error: Colors.black,
  onPrimary: Colors.black,
  onSecondary: Colors.black,
  onSurface: Colors.black,
  onBackground: Colors.black,
  onError: Colors.black,
  brightness: Brightness.light,
);

const ColorScheme _customColorSchemeDark = ColorScheme(
  primary: Color.fromARGB(148, 135, 18, 57),
  secondary: Color.fromARGB(147, 129, 32, 64),
  tertiary: Color.fromARGB(121, 154, 56, 91),
  primaryContainer: Colors.grey,
  surface: Colors.grey,
  background: Colors.white,
  error: Colors.white,
  onPrimary: Colors.white, // Used on search bar for font color
  onSecondary: Colors.white, // For all buttons ---> TEXT AND ICON COLOR
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
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 26, color: Colors.white, fontWeight: FontWeight.normal),
        headline2: TextStyle(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.normal),
        headline3: TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.normal),
        bodyText1: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
        bodyText2: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
      ));

  ThemeData dark = ThemeData.dark().copyWith(
      colorScheme: _customColorSchemeDark,
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 26, color: Colors.white, fontWeight: FontWeight.normal),
        headline2: TextStyle(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.normal),
        headline3: TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.normal),
        bodyText1: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
        bodyText2: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 219, 219, 219),
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
