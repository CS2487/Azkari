class Azkar {
  final String text;
  final String? source;
  final int repeat;
  final String type; // جديد

  Azkar({required this.text, this.source, required this.repeat, required this.type});

  factory Azkar.fromJson(Map<String, dynamic> json) {
    return Azkar(
      text: (json['text'] ?? '').toString(),
      source: json['source']?.toString(),
      repeat: int.tryParse(json['repeat']?.toString() ?? '') ?? 1,
      type: (json['type'] ?? '').toString(), // جديد
    );
  }
}
