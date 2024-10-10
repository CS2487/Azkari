

import 'package:azkar_application/data/models/azkar_entry.dart';
import 'package:azkar_application/app.dart';
import 'package:azkar_application/core/theme/app_theme.dart';
import 'package:azkar_application/data/models/azkar_entry.dart';
import 'package:azkar_application/features/Sebha/sebha_page.dart';
import 'package:azkar_application/features/settings/Provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'dart:convert';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:vibration/vibration.dart';
class AzkarRepository {
  AzkarRepository._();
  static final AzkarRepository instance = AzkarRepository._();

  final Map<String, List<AzkarCategory>> _cache = {};

  Future<List<AzkarCategory>> loadByType(String type) async {
    final key = type.toLowerCase().trim();
    if (_cache.containsKey(key)) return _cache[key]!;

    try {
      final raw = await rootBundle.loadString('assets/json/adhkar.json');
      final data = json.decode(raw) as List<dynamic>;
      final list = data
          .map((e) => AzkarCategory.fromJson(e as Map<String, dynamic>))
          .where((e) =>
      e.category.trim().isNotEmpty &&
          e.array.isNotEmpty &&
          e.category.toLowerCase() == key)
          .toList();
      _cache[key] = list;
      return list;
    } catch (e) {
      return [];
    }
  }
}