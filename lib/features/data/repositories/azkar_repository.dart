

import 'package:azkar_application/features/data/models/azkar_entry.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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