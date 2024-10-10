import 'package:azkar_application/core/utils/haptics.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/settings_repository.dart' show SettingsState;

class SettingsBlocState extends Equatable {
  final SettingsState settings;
  final bool loading;

  const SettingsBlocState({
    required this.settings,
    this.loading = false,
  });

  factory SettingsBlocState.initial() => const SettingsBlocState(
    settings: SettingsState(
      hapticsEnabled: true,
      hapticStrength: HapticStrength.medium,
      morningTime: TimeOfDay(hour: 7, minute: 0),
      eveningTime: TimeOfDay(hour: 19, minute: 0),
      fridayTime: TimeOfDay(hour: 9, minute: 0),
      morningOn: true,
      eveningOn: true,
      fridayOn: true,
    ),
    loading: true,
  );

  SettingsBlocState copyWith({
    SettingsState? settings,
    bool? loading,
  }) {
    return SettingsBlocState(
      settings: settings ?? this.settings,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [settings, loading];
}
