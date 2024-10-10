import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_event.dart';
import 'settings_state.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../core/utils/notification_service.dart';

class _NotificationIds {
  static const morning = 1001;
  static const evening = 1002;
  static const friday = 1003;
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsBlocState> {
  SettingsBloc(this._repo, {NotificationService? notifications})
      : _notifications = notifications ?? NotificationService(),
        super(SettingsBlocState.initial()) {
    on<SettingsStarted>(_onStarted);

    on<SettingsHapticsToggled>(_onHapticsToggled);
    on<SettingsHapticStrengthChanged>(_onHapticStrengthChanged);

    on<SettingsMorningToggled>(_onMorningToggled);
    on<SettingsEveningToggled>(_onEveningToggled);
    on<SettingsFridayToggled>(_onFridayToggled);

    on<SettingsMorningTimePicked>(_onMorningTimePicked);
    on<SettingsEveningTimePicked>(_onEveningTimePicked);
    on<SettingsFridayTimePicked>(_onFridayTimePicked);
  }

  final SettingsRepository _repo;
  final NotificationService _notifications;

  Future<void> _onStarted(
      SettingsStarted event, Emitter<SettingsBlocState> emit) async {
    emit(state.copyWith(loading: true));

    final loaded = _repo.load();

    await _applySchedulingFromState(loaded);

    emit(state.copyWith(settings: loaded, loading: false));
  }

  Future<void> _onHapticsToggled(
      SettingsHapticsToggled event, Emitter<SettingsBlocState> emit) async {
    await _repo.setHaptics(event.enabled);
    emit(state.copyWith(
        settings: state.settings.copyWith(hapticsEnabled: event.enabled)));
  }

  Future<void> _onHapticStrengthChanged(SettingsHapticStrengthChanged event,
      Emitter<SettingsBlocState> emit) async {
    await _repo.setHapticStrength(event.strength);
    emit(state.copyWith(
        settings: state.settings.copyWith(hapticStrength: event.strength)));
  }

  Future<void> _onMorningToggled(
      SettingsMorningToggled event, Emitter<SettingsBlocState> emit) async {
    await _repo.setMorningOn(event.on);
    final s = state.settings.copyWith(morningOn: event.on);
    emit(state.copyWith(settings: s));
    await _rescheduleMorning(s);
  }

  Future<void> _onEveningToggled(
      SettingsEveningToggled event, Emitter<SettingsBlocState> emit) async {
    await _repo.setEveningOn(event.on);
    final s = state.settings.copyWith(eveningOn: event.on);
    emit(state.copyWith(settings: s));
    await _rescheduleEvening(s);
  }

  Future<void> _onFridayToggled(
      SettingsFridayToggled event, Emitter<SettingsBlocState> emit) async {
    await _repo.setFridayOn(event.on);
    final s = state.settings.copyWith(fridayOn: event.on);
    emit(state.copyWith(settings: s));
    await _rescheduleFriday(s);
  }

  Future<void> _onMorningTimePicked(
      SettingsMorningTimePicked event, Emitter<SettingsBlocState> emit) async {
    await _repo.setMorningTime(event.time);
    final s = state.settings.copyWith(morningTime: event.time);
    emit(state.copyWith(settings: s));
    await _rescheduleMorning(s);
  }

  Future<void> _onEveningTimePicked(
      SettingsEveningTimePicked event, Emitter<SettingsBlocState> emit) async {
    await _repo.setEveningTime(event.time);
    final s = state.settings.copyWith(eveningTime: event.time);
    emit(state.copyWith(settings: s));
    await _rescheduleEvening(s);
  }

  Future<void> _onFridayTimePicked(
      SettingsFridayTimePicked event, Emitter<SettingsBlocState> emit) async {
    await _repo.setFridayTime(event.time);
    final s = state.settings.copyWith(fridayTime: event.time);
    emit(state.copyWith(settings: s));
    await _rescheduleFriday(s);
  }

  Future<void> _applySchedulingFromState(SettingsState s) async {
    await _rescheduleMorning(s);
    await _rescheduleEvening(s);
    await _rescheduleFriday(s);
  }

  Future<void> _rescheduleMorning(SettingsState s) async {
    await _notifications.cancelNotification(_NotificationIds.morning);
    if (s.morningOn) {
      await _notifications.scheduleDailyNotification(
        id: _NotificationIds.morning,
        title: 'أذكار الصباح',
        body: 'لا تنسَ قراءة أذكار الصباح',
        hour: s.morningTime.hour,
        minute: s.morningTime.minute,
      );
    }
  }

  Future<void> _rescheduleEvening(SettingsState s) async {
    await _notifications.cancelNotification(_NotificationIds.evening);
    if (s.eveningOn) {
      await _notifications.scheduleDailyNotification(
        id: _NotificationIds.evening,
        title: 'أذكار المساء',
        body: 'لا تنسَ قراءة أذكار المساء',
        hour: s.eveningTime.hour,
        minute: s.eveningTime.minute,
      );
    }
  }

  Future<void> _rescheduleFriday(SettingsState s) async {
    await _notifications.cancelNotification(_NotificationIds.friday);
    if (s.fridayOn) {
      await _notifications.scheduleFridayNotification(
        id: _NotificationIds.friday,
        title: 'تذكير الجمعة',
        body: 'أكثِر من الصلاة على النبي ﷺ وقراءة الكهف',
        hour: s.fridayTime.hour,
        minute: s.fridayTime.minute,
      );
    }
  }
}
