import 'package:azkar_application/core/app/my_app.dart';
import 'package:azkar_application/core/utils/notification_service.dart';
import 'package:azkar_application/core/utils/timezone_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
