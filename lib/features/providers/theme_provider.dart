import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode;
  final SharedPreferences prefs;

  ThemeProvider(this.prefs) : _themeMode = _getThemeModeFromPrefs(prefs);

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  static ThemeMode _getThemeModeFromPrefs(SharedPreferences prefs) {
    final themeString = prefs.getString('theme_mode') ?? 'system';
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  void _saveThemeMode(ThemeMode mode) {
    _themeMode = mode;
    String themeString;
    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
      default:
        themeString = 'system';
        break;
    }
    prefs.setString('theme_mode', themeString);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _saveThemeMode(mode);
  }

  void toggleTheme() {
    // لو تريد التبديل بين light/dark/system
    if (_themeMode == ThemeMode.system) {
      _saveThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      _saveThemeMode(ThemeMode.light);
    } else {
      _saveThemeMode(ThemeMode.system);
    }
  }
}
