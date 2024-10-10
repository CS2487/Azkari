import 'dart:convert';
import 'package:azkar_application/data/models/azkar_entry.dart';
import 'package:flutter/services.dart' show rootBundle;

class AzkarRepository {
  AzkarRepository._();
  static final AzkarRepository instance = AzkarRepository._();

  final Map<String, List<Azkar>> _cache = {};

  /// تحميل الأذكار حسب النوع
  Future<List<Azkar>> loadByType(String type) async {
    final key = type.toLowerCase();
    if (_cache.containsKey(key)) return _cache[key]!;

    try {
      final raw = await rootBundle.loadString('assets/json/azkar.json');
      final data = json.decode(raw) as List<dynamic>;
      final list = data
          .map((e) => Azkar.fromJson(e as Map<String, dynamic>))
          .where((e) => e.text.trim().isNotEmpty && e.repeat > 0 && (e.type.toLowerCase() == key))
          .toList();
      _cache[key] = list;
      return list;
    } catch (_) {
      return [];
    }
  }
}
