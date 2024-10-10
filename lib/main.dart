

import 'package:azkar_application/app.dart';
import 'package:azkar_application/core/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/timezone_helper.dart';

Future<void> main(dynamic args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await TimeZoneHelper.init();
  await NotificationService().init();

  runApp(AzkarApp(prefs: prefs));
}

