// lib/core/theme/app_spaces.dart

import 'package:flutter/material.dart';

abstract class AppSpaces {
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
  static const Widget gapExtraSmall = SizedBox(height: extraSmall);
  static const Widget gapSmall = SizedBox(height: small);
  static const Widget gapMedium = SizedBox(height: medium);
  static const Widget gapLarge = SizedBox(height: large);
}
