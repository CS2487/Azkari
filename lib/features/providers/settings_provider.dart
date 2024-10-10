import 'package:azkar_application/core/utils/haptics.dart';
import 'package:azkar_application/core/utils/notification_service.dart';
import 'package:azkar_application/features/data/models/settings_model.dart';
import 'package:azkar_application/features/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository repo;
  SettingsProvider(this.repo);

  bool loading = true;
  late SettingsStateModel settings;

  Future<void> load() async {
    settings = repo.load();
    loading = false;
    notifyListeners();
    await _refreshSchedules();
  }

  Future<void> toggleHaptics(bool enabled) async {
    settings = settings.copyWith(hapticsEnabled: enabled);
    await repo.setHaptics(enabled);
    notifyListeners();
  }

  Future<void> setHapticStrength(HapticStrength strength) async {
    settings = settings.copyWith(hapticStrength: strength);
    await repo.setHapticStrength(strength);
    notifyListeners();
  }

  Future<void> setMorningOn(bool on) async {
    settings = settings.copyWith(morningOn: on);
    await repo.setMorningOn(on);
    notifyListeners();
    await _scheduleMorning();
  }

  Future<void> setEveningOn(bool on) async {
    settings = settings.copyWith(eveningOn: on);
    await repo.setEveningOn(on);
    notifyListeners();
    await _scheduleEvening();
  }

  Future<void> setFridayOn(bool on) async {
    settings = settings.copyWith(fridayOn: on);
    await repo.setFridayOn(on);
    notifyListeners();
    await _scheduleFriday();
  }

  Future<void> pickMorningTime(TimeOfDay t) async {
    settings = settings.copyWith(morningTime: t);
    await repo.setMorningTime(t);
    notifyListeners();
    await _scheduleMorning();
  }

  Future<void> pickEveningTime(TimeOfDay t) async {
    settings = settings.copyWith(eveningTime: t);
    await repo.setEveningTime(t);
    notifyListeners();
    await _scheduleEvening();
  }

  Future<void> pickFridayTime(TimeOfDay t) async {
    settings = settings.copyWith(fridayTime: t);
    await repo.setFridayTime(t);
    notifyListeners();
    await _scheduleFriday();
  }

  Future<void> disableAllNotifications() async {
    await NotificationService().cancelAll();
    settings =
        settings.copyWith(morningOn: false, eveningOn: false, fridayOn: false);
    await repo.setMorningOn(false);
    await repo.setEveningOn(false);
    await repo.setFridayOn(false);
    notifyListeners();
  }

  Future<void> maybeHaptic() async {
    if (!settings.hapticsEnabled) return;
    if (await Vibration.hasVibrator()) {
      switch (settings.hapticStrength) {
        case HapticStrength.light:
          Vibration.vibrate(duration: 50, amplitude: 50);
          break;
        case HapticStrength.medium:
          Vibration.vibrate(duration: 100, amplitude: 128);
          break;
        case HapticStrength.strong:
          Vibration.vibrate(duration: 200, amplitude: 255);
          break;
      }
    }
  }

  Future<void> _refreshSchedules() async {
    await _scheduleMorning();
    await _scheduleEvening();
    await _scheduleFriday();
  }

  Future<void> _scheduleMorning() async {
    if (!settings.morningOn) {
      await NotificationService().cancelNotification(101);
      return;
    }
    await NotificationService().scheduleDailyNotification(
      id: 101,
      title: 'أذكار الصباح',
      body: 'حان وقت أذكار الصباح',
      hour: settings.morningTime.hour,
      minute: settings.morningTime.minute,
    );
  }

  Future<void> _scheduleEvening() async {
    if (!settings.eveningOn) {
      await NotificationService().cancelNotification(102);
      return;
    }
    await NotificationService().scheduleDailyNotification(
      id: 102,
      title: 'أذكار المساء',
      body: 'حان وقت أذكار المساء',
      hour: settings.eveningTime.hour,
      minute: settings.eveningTime.minute,
    );
  }

  Future<void> _scheduleFriday() async {
    if (!settings.fridayOn) {
      await NotificationService().cancelNotification(103);
      return;
    }
    await NotificationService().scheduleFridayNotification(
      id: 103,
      title: 'تذكير الجمعة',
      body: 'لا تنس قراءة سورة الكهف والصلاة على النبي',
      hour: settings.fridayTime.hour,
      minute: settings.fridayTime.minute,
    );
  }
}
