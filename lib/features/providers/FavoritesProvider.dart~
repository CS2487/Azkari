import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map<String, String>> _favorites = [];

  List<Map<String, String>> get favorites => List.unmodifiable(_favorites);

  bool isFavoriteType(String type) {
    return _favorites.any((e) => (e['type'] ?? '') == type);
  }

  void toggleFavorite(Map<String, String> item) {
    final type = item['type'] ?? '';
    final idx = _favorites.indexWhere((e) => (e['type'] ?? '') == type);
    if (idx >= 0) {
      _favorites.removeAt(idx);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }
}
