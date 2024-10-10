import 'package:azkar_application/core/utils/haptics.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

class SettingsHapticsToggled extends SettingsEvent {
  final bool enabled;
  const SettingsHapticsToggled(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class SettingsHapticStrengthChanged extends SettingsEvent {
  final HapticStrength strength;
  const SettingsHapticStrengthChanged(this.strength);
  @override
  List<Object?> get props => [strength];
}

class SettingsMorningToggled extends SettingsEvent {
  final bool on;
  const SettingsMorningToggled(this.on);
  @override
  List<Object?> get props => [on];
}

class SettingsEveningToggled extends SettingsEvent {
  final bool on;
  const SettingsEveningToggled(this.on);
  @override
  List<Object?> get props => [on];
}

class SettingsFridayToggled extends SettingsEvent {
  final bool on;
  const SettingsFridayToggled(this.on);
  @override
  List<Object?> get props => [on];
}

class SettingsMorningTimePicked extends SettingsEvent {
  final TimeOfDay time;
  const SettingsMorningTimePicked(this.time);
  @override
  List<Object?> get props => [time];
}

class SettingsEveningTimePicked extends SettingsEvent {
  final TimeOfDay time;
  const SettingsEveningTimePicked(this.time);
  @override
  List<Object?> get props => [time];
}

class SettingsFridayTimePicked extends SettingsEvent {
  final TimeOfDay time;
  const SettingsFridayTimePicked(this.time);
  @override
  List<Object?> get props => [time];
}
