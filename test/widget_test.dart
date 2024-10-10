
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:azkar_application/main.dart' as app;

void main() {

  group('System Test - Azkar App', () {
    testWidgets('Test Favorites, Theme, Language, Notifications',
            (WidgetTester tester) async {
          // تشغيل التطبيق
          app.main();
          await tester.pumpAndSettle();

          // ===================== Test AppBar =====================
          expect(find.byType(AppBar), findsWidgets);
          expect(find.text('الأذكار'), findsWidgets); // أو حسب الصفحة الرئيسية

          // ===================== Test Favorites =====================
          // اذهب للذكر الأول واضغط زر المفضلة
          final firstFavoriteButton = find.byIcon(Icons.favorite_border).first;
          await tester.tap(firstFavoriteButton);
          await tester.pumpAndSettle();

          // تحقق أنه ظهر في صفحة المفضلة
          await tester.tap(find.byIcon(Icons.favorite)); // زر الانتقال للمفضلة
          await tester.pumpAndSettle();
          expect(find.byType(ListView), findsWidgets);

          // ===================== Test Theme =====================
          // اذهب للإعدادات
          await tester.tap(find.byIcon(Icons.settings));
          await tester.pumpAndSettle();

          // اضغط تغيير الثيم إلى Dark
          await tester.tap(find.text('الثيم'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Dark'));
          await tester.pumpAndSettle();
          // تحقق أن الثيم تغير (يمكن التحقق من لون AppBar)
          final appBar = tester.widget<AppBar>(find.byType(AppBar).first);
          expect(appBar.backgroundColor, isNot(Colors.white));

          // ===================== Test Language =====================
          await tester.tap(find.text('اللغة'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('English'));
          await tester.pumpAndSettle();
          expect(find.text('Settings'), findsWidgets); // تحقق من الترجمة

          // ===================== Test Notifications =====================
          // هنا لا يمكن اختبار الإشعار الظاهر فعلياً على الجهاز في Integration Test
          // لكن يمكن التأكد من استدعاء الدوال عبر mocking (advanced)
          // مثال: Mock NotificationService.scheduleDailyNotification

          // ===================== Test Haptics =====================
          // مثل Notifications، الاهتزاز يحتاج mocking للتحقق منه
        });
  });
}
