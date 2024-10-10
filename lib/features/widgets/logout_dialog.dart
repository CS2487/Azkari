import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class LogoutDialog extends StatelessWidget {
  final bool showCloseButton;

  const LogoutDialog({super.key, this.showCloseButton = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // زر الإغلاق (X) أعلى يمين
            if (showCloseButton)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'إغلاق',
                ),
              ),

            // أيقونة تسجيل الخروج
            Icon(Icons.logout, size: 50, color: theme.colorScheme.error),
            const SizedBox(height: 16),

            // العنوان
            Text(
              'تسجيل الخروج',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            const Text(
              'هل أنت متأكد أنك تريد تسجيل الخروج من التطبيق؟',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // زر تأكيد تسجيل الخروج بعرض كامل
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (Platform.isAndroid) {
                    SystemNavigator.pop(); // خروج للأندرويد
                  } else if (Platform.isIOS) {
                    exit(0); // خروج إجباري للـ iOS
                  }
                },
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
