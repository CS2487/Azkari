import 'package:azkar_application/core/utils/notification_service.dart';
import 'package:azkar_application/core/utils/timezone_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azkar_application/core/utils/nav.dart';
import 'package:azkar_application/features/data/repositories/azkar_repository.dart';
import 'package:azkar_application/features/data/repositories/settings_repository.dart';
import 'package:azkar_application/features/providers/adhkar_provider.dart';
import 'package:azkar_application/features/providers/favorites_provider.dart';
import 'package:azkar_application/features/providers/locale_provider.dart';
import 'package:azkar_application/features/providers/theme_provider.dart';
import 'package:azkar_application/features/screens/bottom_nav_bar.dart';
import 'package:azkar_application/features/providers/search_provider.dart';
import 'package:azkar_application/features/providers/settings_provider.dart';
import 'package:azkar_application/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  await TimeZoneHelper.init();
  await NotificationService().init();

  runApp(AzkarApp(prefs: prefs));
}

class AzkarApp extends StatelessWidget {
  final SharedPreferences prefs;
  const AzkarApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    final settingsRepo = SettingsRepository(prefs);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => SettingsProvider(settingsRepo)..load()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(
            create: (_) => AzkarProvider(AzkarRepository.instance)),
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: Consumer3<SettingsProvider, ThemeProvider, LocaleProvider>(
        builder: (context, settings, theme, locale, _) {
          return MaterialApp(
            navigatorKey: navKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode,
            locale: locale.locale,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const BottomNavBar(),
          );
        },
      ),
    );
  }
}
