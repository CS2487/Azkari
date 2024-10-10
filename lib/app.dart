import 'package:azkar_application/features/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/nav.dart';
import 'data/repositories/azkar_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'features/azkar/bloc/azkar_bloc.dart';
import 'features/favorites/bloc/favorites_bloc.dart';
import 'features/search/bloc/search_bloc.dart';
import 'features/settings/bloc/settings_bloc.dart';
import 'features/settings/bloc/settings_event.dart';
import 'features/settings/bloc/settings_state.dart';
class AzkarApp extends StatelessWidget {
  const AzkarApp({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final settingsRepo = SettingsRepository(prefs);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
            SettingsBloc(settingsRepo)..add(const SettingsStarted())),
        BlocProvider(create: (_) => FavoritesBloc()),
        BlocProvider(create: (_) => SearchBloc()),
        BlocProvider(create: (_) => AzkarBloc(AzkarRepository.instance)),
      ],
      child: BlocBuilder<SettingsBloc, SettingsBlocState>(
        builder: (context, s) {
          return MaterialApp(
            navigatorKey: navKey,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const BottomNavBar(),

            locale: const Locale('ar'),
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );

        },
      ),
    );
  }
}
