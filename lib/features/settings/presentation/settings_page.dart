import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar_application/core/utils/haptics.dart';
import 'package:azkar_application/core/utils/notification_service.dart';
import 'package:azkar_application/features/settings/bloc/settings_bloc.dart';
import 'package:azkar_application/features/settings/bloc/settings_event.dart';
import 'package:azkar_application/features/settings/bloc/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _pickTime(BuildContext context, {required String type}) async {
    final bloc = context.read<SettingsBloc>();
    final s = bloc.state.settings;
    final initial = switch (type) {
      "morning" => s.morningTime,
      "evening" => s.eveningTime,
      "friday" => s.fridayTime,
      _ => TimeOfDay.now(),
    };

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      switch (type) {
        case "morning":
          bloc.add(SettingsMorningTimePicked(picked));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم ضبط وقت أذكار الصباح')),
          );
          break;
        case "evening":
          bloc.add(SettingsEveningTimePicked(picked));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم ضبط وقت أذكار المساء')),
          );
          break;
        case "friday":
          bloc.add(SettingsFridayTimePicked(picked));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم ضبط وقت تذكير الجمعة')),
          );
          break;
      }
    }
  }

  Widget _sectionHeader(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
      );

  Widget _sectionCard(Widget child) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: child,
      );

  Widget _appInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.menu_book, size: 48),
          const SizedBox(height: 8),
          Text(
            'أذكاري',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('الإصدار 1.0.0', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _hapticsSection(BuildContext context, SettingsBlocState state) {
    final s = state.settings;
    final theme = Theme.of(context);
    return _sectionCard(
      Card(
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('اهتزاز عند العد/الانتقال'),
              value: s.hapticsEnabled,
              onChanged: (v) =>
                  context.read<SettingsBloc>().add(SettingsHapticsToggled(v)),
              secondary: const Icon(Icons.vibration),
            ),
            if (s.hapticsEnabled)
              Column(
                children: HapticStrength.values.map((strength) {
                  final title = switch (strength) {
                    HapticStrength.light => "خفيف",
                    HapticStrength.medium => "متوسط",
                    HapticStrength.strong => "قوي",
                  };
                  return RadioListTile<HapticStrength>(
                    title: Text(title, style: theme.textTheme.bodyMedium),
                    value: strength,
                    groupValue: s.hapticStrength,
                    onChanged: (val) {
                      if (val != null) {
                        context
                            .read<SettingsBloc>()
                            .add(SettingsHapticStrengthChanged(val));
                      }
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _morningTile(BuildContext context, SettingsBlocState state) {
    final s = state.settings;
    final theme = Theme.of(context);
    return _sectionCard(
      Card(
        child: ListTile(
          leading: const Icon(Icons.wb_sunny_outlined),
          title: const Text('أذكار الصباح'),
          subtitle: Text('الوقت: ${s.morningTime.format(context)}',
              style: theme.textTheme.bodyMedium),
          trailing: Switch(
            value: s.morningOn,
            onChanged: (v) =>
                context.read<SettingsBloc>().add(SettingsMorningToggled(v)),
            activeColor: theme.colorScheme.primary,
          ),
          onTap: () => _pickTime(context, type: "morning"),
        ),
      ),
    );
  }

  Widget _eveningTile(BuildContext context, SettingsBlocState state) {
    final s = state.settings;
    final theme = Theme.of(context);
    return _sectionCard(
      Card(
        child: ListTile(
          leading: const Icon(Icons.nights_stay_outlined),
          title: const Text('أذكار المساء'),
          subtitle: Text('الوقت: ${s.eveningTime.format(context)}',
              style: theme.textTheme.bodyMedium),
          trailing: Switch(
            value: s.eveningOn,
            onChanged: (v) =>
                context.read<SettingsBloc>().add(SettingsEveningToggled(v)),
            activeColor: theme.colorScheme.primary,
          ),
          onTap: () => _pickTime(context, type: "evening"),
        ),
      ),
    );
  }

  Widget _fridayTile(BuildContext context, SettingsBlocState state) {
    final s = state.settings;
    final theme = Theme.of(context);
    return _sectionCard(
      Card(
        child: ListTile(
          leading: const Icon(Icons.mosque),
          title: const Text('تذكير الجمعة'),
          subtitle: Text('الوقت: ${s.fridayTime.format(context)}',
              style: theme.textTheme.bodyMedium),
          trailing: Switch(
            value: s.fridayOn,
            onChanged: (v) =>
                context.read<SettingsBloc>().add(SettingsFridayToggled(v)),
            activeColor: theme.colorScheme.primary,
          ),
          onTap: () => _pickTime(context, type: "friday"),
        ),
      ),
    );
  }

  Widget _disableAllNotificationsTile(BuildContext context) {
    return _sectionCard(
      Card(
        child: ListTile(
          leading: const Icon(Icons.notifications_off),
          title: const Text('إيقاف كل الإشعارات'),
          onTap: () async {
            await NotificationService().cancelAll();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إيقاف جميع الإشعارات')),
            );
            final bloc = context.read<SettingsBloc>();
            bloc.add(const SettingsMorningToggled(false));
            bloc.add(const SettingsEveningToggled(false));
            bloc.add(const SettingsFridayToggled(false));
          },
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context) {
    return _sectionCard(
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _appInfo(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingsBloc, SettingsBlocState>(
      builder: (context, state) {
        final bgColor = Theme.of(context).scaffoldBackgroundColor;
        final appBarTheme = Theme.of(context).appBarTheme;

        if (state.loading) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              title: const Text('الإعدادات'),
              backgroundColor: appBarTheme.backgroundColor,
              iconTheme: appBarTheme.iconTheme,
              elevation: appBarTheme.elevation,
              centerTitle: appBarTheme.centerTitle ?? true,
              systemOverlayStyle: isDark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text('الإعدادات'),
            backgroundColor: appBarTheme.backgroundColor,
            iconTheme: appBarTheme.iconTheme,
            elevation: appBarTheme.elevation,
            centerTitle: appBarTheme.centerTitle ?? true,
            systemOverlayStyle: isDark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12),
            children: [
              _sectionHeader(context, 'الإعدادات العامة'),
              _hapticsSection(context, state),
              const SizedBox(height: 12),
              _sectionHeader(context, 'التنبيهات'),
              _morningTile(context, state),
              _eveningTile(context, state),
              _fridayTile(context, state),
              _disableAllNotificationsTile(context),
              const SizedBox(height: 12),
              _sectionHeader(context, 'معلومات'),
              _infoCard(context),
            ],
          ),
        );
      },
    );
  }


}
