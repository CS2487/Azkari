import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _prefsKey = 'favorites';
  final List<Map<String, dynamic>> _favorites = [];

  FavoritesProvider() {
    _loadFavorites();
  }

  List<Map<String, dynamic>> get favorites => List.unmodifiable(_favorites);

  bool isFavoriteType(String type) {
    return _favorites.any((e) => (e['type'] ?? '') == type);
  }

  Future<void> toggleFavorite(Map<String, dynamic> item) async {
    final type = item['type'] ?? '';
    final idx = _favorites.indexWhere((e) => (e['type'] ?? '') == type);

    if (idx >= 0) {
      _favorites.removeAt(idx);
    } else {
      _favorites.add(item);
    }

    notifyListeners();
    await _saveFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      _favorites.clear();
      _favorites.addAll(list.cast<Map<String, dynamic>>());
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_favorites);
    await prefs.setString(_prefsKey, raw);
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
