import 'dart:convert';
import 'dart:io';

///How to Rub  json
///dart run .\Scripts\compress_json.dart
void main() async {
  // مسار الملف الأصلي
  final inputFile = File('assets/json/adhkar.json');

  // قراءة محتوى الملف
  final content = await inputFile.readAsString();

  // تحويل النص JSON إلى خريطة
  final jsonData = jsonDecode(content);

  // إعادة الكتابة بدون مسافات أو تبويبات
  final compressed = jsonEncode(jsonData);

  // مسار الملف المضغوط
  final outputFile = File('assets/json/adhkar.json');

  // كتابة الملف المضغوط
  await outputFile.writeAsString(compressed);
}
