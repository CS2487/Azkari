import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale;
  final SharedPreferences prefs;

  LocaleProvider(this.prefs)
      : _locale = Locale(prefs.getString('language_code') ?? 'ar') {
    _loadLocale();
  }

  Locale get locale => _locale;
  Future<void> _loadLocale() async {
    final languageCode = prefs.getString('language_code') ?? 'ar';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  void toggleLocale() {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('ar', 'AE');
    } else {
      _locale = const Locale('en', 'US');
    }
    // Save the new locale to SharedPreferences
    prefs.setString('language_code', _locale.languageCode);
    notifyListeners();
  }

  /// Set a specific locale
  void setLocale(Locale locale) {
    _locale = locale;
    prefs.setString('language_code', locale.languageCode);
    notifyListeners();
  }

  /// Check if current locale is Arabic
  bool get isArabic => _locale.languageCode == 'ar';

  /// Check if current locale is English
  bool get isEnglish => _locale.languageCode == 'en';
}
