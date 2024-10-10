import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFF2684D);
  static const Color darkBackground = Color(0xFF393939);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;

  // 🌞 Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      dialogBackgroundColor: whiteColor,
      colorScheme: _lightColorScheme,
      appBarTheme: _lightAppBarTheme,
      scaffoldBackgroundColor: whiteColor,

      // Time Picker
      timePickerTheme: TimePickerThemeData(
        backgroundColor: whiteColor,
        dialBackgroundColor: Colors.grey.shade200,
        dialHandColor: primaryColor,
        hourMinuteColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryColor
              : Colors.grey.shade100,
        ),
        hourMinuteTextColor: blackColor,
        entryModeIconColor: primaryColor,
        helpTextStyle: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardTheme(
        color: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      inputDecorationTheme: _inputDecorationTheme(blackColor),
      elevatedButtonTheme: _elevatedButtonTheme(whiteColor, primaryColor),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        whiteColor,
        darkBackground,
      ),
      textTheme: _getTextTheme(),
      splashFactory: InkRipple.splashFactory,
      splashColor: primaryColor.withOpacity(0.08),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: primaryColor,
        selectionColor: primaryColor.withOpacity(0.6),
        cursorColor: primaryColor,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // 🌙 Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      dialogBackgroundColor: darkBackground,
      colorScheme: _darkColorScheme,
      appBarTheme: _darkAppBarTheme,
      scaffoldBackgroundColor: blackColor,

      // Time Picker
      timePickerTheme: TimePickerThemeData(
        backgroundColor: darkBackground,
        dialBackgroundColor: blackColor,
        dialHandColor: primaryColor,
        hourMinuteColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryColor
              : Colors.grey.shade800,
        ),
        hourMinuteTextColor: whiteColor,
        entryModeIconColor: primaryColor,
        helpTextStyle: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardTheme(
        color: darkBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      inputDecorationTheme: _inputDecorationTheme(whiteColor),
      elevatedButtonTheme: _elevatedButtonTheme(whiteColor, blackColor),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        darkBackground,
        whiteColor,
      ),
      textTheme: _getTextTheme(),
      splashFactory: InkRipple.splashFactory,
      splashColor: primaryColor.withOpacity(0.08),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: primaryColor,
        selectionColor: primaryColor.withOpacity(0.6),
        cursorColor: primaryColor,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // 🎨 Color Schemes
  static const ColorScheme _lightColorScheme = ColorScheme(
    primary: primaryColor,
    secondary: blackColor,
    surface: whiteColor,
    error: primaryColor,
    onPrimary: whiteColor,
    onSecondary: whiteColor,
    onSurface: blackColor,
    onError: whiteColor,
    brightness: Brightness.light,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    primary: primaryColor,
    secondary: whiteColor,
    surface: blackColor,
    error: primaryColor,
    onPrimary: blackColor,
    onSecondary: blackColor,
    onSurface: whiteColor,
    onError: blackColor,
    brightness: Brightness.dark,
  );

  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,

    backgroundColor: whiteColor, // ✅ اللون الرئيسي
    iconTheme: IconThemeData(color: blackColor),
  );

  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: blackColor, // ✅ اللون الرئيسي
    iconTheme: IconThemeData(color: whiteColor),
  );

  // 🎨 Input Decoration
  static InputDecorationTheme _inputDecorationTheme(Color borderColor) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // 🎨 Elevated Button
  static ElevatedButtonThemeData _elevatedButtonTheme(
      Color backgroundColor, Color foregroundColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // 🎨 FAB
  static FloatingActionButtonThemeData _floatingActionButtonTheme(
      Color backgroundColor, Color foregroundColor) {
    return FloatingActionButtonThemeData(
      shape: const CircleBorder(),
      elevation: 1,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  // 🎨 Text Theme
  static TextTheme _getTextTheme() {
    const fontFamily = 'Roboto';

    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        height: 1.3,
      ),
    );
  }
}
