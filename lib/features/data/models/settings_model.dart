import 'package:azkar_application/core/utils/haptics.dart';
import 'package:flutter/material.dart';

class SettingsStateModel {
  final bool hapticsEnabled;
  final HapticStrength hapticStrength;
  final TimeOfDay morningTime;
  final TimeOfDay eveningTime;
  final TimeOfDay fridayTime;
  final bool morningOn;
  final bool eveningOn;
  final bool fridayOn;

  const SettingsStateModel({
    required this.hapticsEnabled,
    required this.hapticStrength,
    required this.morningTime,
    required this.eveningTime,
    required this.fridayTime,
    required this.morningOn,
    required this.eveningOn,
    required this.fridayOn,
  });

  SettingsStateModel copyWith({
    bool? hapticsEnabled,
    HapticStrength? hapticStrength,
    TimeOfDay? morningTime,
    TimeOfDay? eveningTime,
    TimeOfDay? fridayTime,
    bool? morningOn,
    bool? eveningOn,
    bool? fridayOn,
  }) {
    return SettingsStateModel(
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      hapticStrength: hapticStrength ?? this.hapticStrength,
      morningTime: morningTime ?? this.morningTime,
      eveningTime: eveningTime ?? this.eveningTime,
      fridayTime: fridayTime ?? this.fridayTime,
      morningOn: morningOn ?? this.morningOn,
      eveningOn: eveningOn ?? this.eveningOn,
      fridayOn: fridayOn ?? this.fridayOn,
    );
  }
}
