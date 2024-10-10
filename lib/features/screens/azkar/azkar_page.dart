

import 'package:azkar_application/app.dart';
import 'package:azkar_application/core/theme/app_theme.dart';
import 'package:azkar_application/core/utils/haptics.dart';
import 'package:azkar_application/features/models/azkar_entry.dart';
import 'package:azkar_application/features/Sebha/sebha_page.dart';
import 'package:azkar_application/features/azkar/Adhkar_Provider/adhkar_provider.dart';
import 'package:azkar_application/features/settings/Provider/settings_provider.dart';
import 'package:azkar_application/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'dart:convert';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:vibration/vibration.dart';

import 'package:flutter/material.dart';

class AzkarPage extends StatefulWidget {
  final String type;
  const AzkarPage({super.key, required this.type});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final azkarProv = context.read<AzkarProvider>();
      azkarProv.load(widget.type);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _maybeHaptic(SettingsProvider settings) async {
    if (!settings.settings.hapticsEnabled) return;
    if (await Vibration.hasVibrator() ?? false) {
      switch (settings.settings.hapticStrength) {
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

  void _showCompletionMessage() {
    final isMorning = widget.type == "morning";
    Fluttertoast.showToast(
      msg: isMorning
          ? 'تم الانتهاء من أذكار الصباح'
          : 'تم الانتهاء من أذكار المساء',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      fontSize: 16.0,
    );
  }

  Future<void> _pickTimeAndSchedule(BuildContext context) async {
    final settingsProvider = context.read<SettingsProvider>();
    final isMorning = widget.type == "morning";

    final initialTime = isMorning
        ? settingsProvider.settings.morningTime
        : settingsProvider.settings.eveningTime;

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      if (isMorning) {
        await settingsProvider.pickMorningTime(picked);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم ضبط وقت أذكار الصباح')),
        );
      } else {
        await settingsProvider.pickEveningTime(picked);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم ضبط وقت أذكار المساء')),
        );
      }
    }
  }

  void _shareCurrent(List<ZikrItem> list) {
    final page =
    _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;
    if (list.isEmpty) return;
    final index = page.clamp(0, list.length - 1);
    final item = list[index];
    final title = _title();
    final src = (item.source == null || item.source!.trim().isEmpty)
        ? ''
        : '\n[${item.source}]';

    Share.share('من $title\n${item.text}$src\nالتكرار: ${item.count}',
        subject: title);
  }

  String _title() {
    switch (widget.type) {
      case 'morning':
        return 'أذكار الصباح';
      case 'evening':
        return 'أذكار المساء';
      case 'sleep':
        return 'أذكار النوم';
      case 'prayer':
        return 'أذكار بعد الصلاة';
      case 'prayer':
        return 'أذكار دخول/خروج المسجد';
      default:
        return 'الأذكار';
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_title()),
        actions: [
          Consumer<AzkarProvider>(
            builder: (context, azkar, _) => IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareCurrent(azkar.flatList),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: () => _pickTimeAndSchedule(context),
          ),
        ],
      ),
      body: Consumer<AzkarProvider>(
        builder: (context, azkar, _) {
          if (azkar.loading)
            return const Center(child: CircularProgressIndicator());
          if (azkar.error != null)
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(azkar.error!),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => azkar.load(widget.type),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          if (azkar.flatList.isEmpty)
            return const Center(child: Text('لا توجد أذكار'));

          return PageView.builder(
            controller: _pageController,
            itemCount: azkar.flatList.length,
            itemBuilder: (context, index) {
              final item = azkar.flatList[index];
              final current = azkar.counters[index];
              final maxCount = item.count;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(item.text,
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center),
                            if ((item.source ?? '').trim().isNotEmpty)
                              Column(
                                children: [
                                  const SizedBox(height: 12),
                                  Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.source!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.3),
                      thickness: 1.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "الذِكر ${index + 1} من ${azkar.flatList.length}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (current < maxCount) {
                                azkar.incrementAt(index);
                                await _maybeHaptic(
                                    context.read<SettingsProvider>());

                                if (azkar.counters[index] == maxCount) {
                                  Future.delayed(
                                    const Duration(milliseconds: 250),
                                        () async {
                                      if (index < azkar.flatList.length - 1) {
                                        await _maybeHaptic(
                                            context.read<SettingsProvider>());
                                        _pageController.nextPage(
                                          duration:
                                          const Duration(milliseconds: 350),
                                          curve: Curves.easeInOut,
                                        );
                                      } else {
                                        await _maybeHaptic(
                                            context.read<SettingsProvider>());
                                        _showCompletionMessage();
                                      }
                                    },
                                  );
                                }
                              }
                            },
                            onLongPress: () async {
                              if (current > 0) {
                                azkar.decrementAt(index);
                                await _maybeHaptic(
                                    context.read<SettingsProvider>());
                              }
                            },
                            child: CircularPercentIndicator(
                              radius: 36,
                              lineWidth: 6,
                              percent: (current / maxCount).clamp(0.0, 1.0),
                              center: Text(
                                "${current + 1 > maxCount ? maxCount : current + 1}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              progressColor:
                              Theme.of(context).colorScheme.primary,
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                          ),
                          const SizedBox(
                              width: 16), // ← إضافة مسافة بين المؤشر والنص
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                maxCount == 1
                                    ? "مرة واحدة"
                                    : "التكرار: $maxCount",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}