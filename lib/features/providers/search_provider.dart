import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<Map<String, String>> _allItems = [];
  List<Map<String, String>> _results = [];

  List<Map<String, String>> get results => _results;

  void setItems(List<Map<String, dynamic>> items) {
    _allItems = items
        .map((e) => {
      "text": (e["title"] ?? "").toString(),
      "type": (e["type"] ?? "").toString(),
    })
        .toList();
    _results = _allItems; // عرض كل العناصر افتراضياً
    notifyListeners();
  }

  void updateQuery(String query) {
    if (query.isEmpty) {
      _results = _allItems;
    } else {
      _results = _allItems
          .where((e) => e["text"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
