class AzkarCategory {
  final int id;
  final String category;
  final List<ZikrItem> array;

  AzkarCategory({
    required this.id,
    required this.category,
    required this.array,
  });

  factory AzkarCategory.fromJson(Map<String, dynamic> json) {
    return AzkarCategory(
      id: json['id'] as int,
      category: json['category'] as String,
      array: (json['array'] as List<dynamic>)
          .map((e) => ZikrItem.fromJson(e))
          .toList(),
    );
  }
}

class ZikrItem {
  final int id;
  final String text;
  final int count;
  final String? source;

  ZikrItem({
    required this.id,
    required this.text,
    required this.count,
    this.source,
  });

  factory ZikrItem.fromJson(Map<String, dynamic> json) {
    return ZikrItem(
      id: json['id'] as int,
      text: json['text'] as String,
      count: json['count'] as int,
      source: json['source']?.toString(),
    );
  }
}
