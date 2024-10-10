import 'package:azkar_application/features/data/models/azkar_entry.dart';
import 'package:azkar_application/features/data/repositories/azkar_repository.dart';
import 'package:flutter/material.dart';

class AzkarProvider extends ChangeNotifier {
  final AzkarRepository repo;
  AzkarProvider(this.repo);

  bool loading = false;
  String? error;
  List<AzkarCategory> items = [];
  List<int> counters = [];

  Future<void> load(String type) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final list = await repo.loadByType(type);
      items = list;
      counters = List.filled(flatList.length, 0); // ← مهم
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      error = 'حصل خطأ أثناء تحميل الأذكار';
      notifyListeners();
    }
  }

  void incrementAt(int index) {
    if (index < 0 || index >= counters.length) return;
    counters[index] = counters[index] + 1;
    notifyListeners();
  }

  void decrementAt(int index) {
    if (index < 0 || index >= counters.length) return;
    if (counters[index] > 0) {
      counters[index] = counters[index] - 1;
      notifyListeners();
    }
  }

  List<ZikrItem> get flatList => items.expand((cat) => cat.array).toList();
}
