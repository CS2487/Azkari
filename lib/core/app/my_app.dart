import 'package:smart_management/core/imports/imports.dart';
import 'package:smart_management/core/theme/app_theme.dart';
import 'package:smart_management/core/theme/mode_theme.dart';
class DafterAccounts extends StatelessWidget {
  final SharedPreferences prefs;
  const DafterAccounts({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)), // 👈 أضفنا ThemeProvider مع prefs
        ChangeNotifierProvider(
            create: (_) => ClientProvider(ClientRepository())),
        ChangeNotifierProvider(
            create: (_) => TransactionProvider(
                TransactionRepository(), ClientRepository())),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, localeProvider, themeProvider, child) {
          return MaterialApp(
            title: 'دفتر الحسابات',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'AE'),
              Locale('en', 'US'),
            ],
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode, // 👈 ربط بالـ Provider

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode;
  final SharedPreferences prefs;

  ThemeProvider(this.prefs)
      : _themeMode = _getThemeModeFromPrefs(prefs);

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
class LocaleProvider with ChangeNotifier {
  Locale _locale;
  final SharedPreferences prefs;

  LocaleProvider(this.prefs)
      : _locale = Locale(prefs.getString('language_code') ?? 'ar') {
    _loadLocale();
  }

  Locale get locale => _locale;

  /// Load locale from SharedPreferences
  Future<void> _loadLocale() async {
    final languageCode = prefs.getString('language_code') ?? 'ar';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  /// Toggle locale between 'en' and 'ar'
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
