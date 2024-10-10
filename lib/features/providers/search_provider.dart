

import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<Map<String, String>> _results = [];
  List<Map<String, String>> get results => _results;

  // بيانات اقتراحات ثابتة كمثال
  final List<Map<String, String>> _all = const [
    {"text": "أذكار الصباح", "type": "morning"},
    {"text": "أذكار المساء", "type": "evening"},
    {"text": "أذكار بعد الصلاة", "type": "prayer"},
  ];

  void updateQuery(String q) {
    final query = q.trim();
    if (query.isEmpty) {
      _results = [];
    } else {
      _results = _all.where((e) => (e["text"] ?? '').contains(query)).toList();
    }
    notifyListeners();
  }
}
