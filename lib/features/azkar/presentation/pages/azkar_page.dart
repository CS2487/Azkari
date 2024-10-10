import 'package:azkar_application/features/settings/bloc/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';
import 'package:azkar_application/data/models/azkar_entry.dart';
import 'package:azkar_application/features/azkar/bloc/azkar_bloc.dart';
import 'package:azkar_application/features/azkar/bloc/azkar_event.dart';
import 'package:azkar_application/features/azkar/bloc/azkar_state.dart';
import 'package:azkar_application/features/settings/bloc/settings_bloc.dart';
import 'package:azkar_application/features/settings/bloc/settings_state.dart';
import 'package:azkar_application/core/utils/haptics.dart';

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
    context.read<AzkarBloc>().add(AzkarLoadRequested(widget.type));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _maybeHaptic(SettingsBlocState s) async {
    if (!s.settings.hapticsEnabled) return;
    if (await Vibration.hasVibrator() ?? false) {
      switch (s.settings.hapticStrength) {
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

  void _shareCurrentDhikr(List<Azkar> azkar) {
    final page =
        _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;
    if (azkar.isEmpty) return;
    final index = page.clamp(0, azkar.length - 1);
    final item = azkar[index];
    final title = _title();
    final src = item.source == null ? '' : '\n[${item.source}]';
    Share.share('من $title\n${item.text}$src\n${"التكرار: ${item.repeat}"}',
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
      case 'masjid':
        return 'أذكار دخول/خروج المسجد';
      default:
        return 'الأذكار';
    }
  }

  Future<void> _pickTimeAndSchedule(BuildContext context,
      {required bool isMorning}) async {
    final bloc = context.read<SettingsBloc>();
    final s = bloc.state.settings;
    final initial = isMorning ? s.morningTime : s.eveningTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      if (isMorning) {
        bloc.add(SettingsMorningTimePicked(picked));
      } else {
        bloc.add(SettingsEveningTimePicked(picked));
      }
      Fluttertoast.showToast(msg: 'تم ضبط وقت التذكير اليومي');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title(), style: textTheme.titleLarge),
        actions: [
          BlocBuilder<AzkarBloc, AzkarState>(
            builder: (context, st) => IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareCurrentDhikr(st.items),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: () => _pickTimeAndSchedule(context,
                isMorning: widget.type == 'morning'),
          ),
        ],
      ),
      body: BlocBuilder<AzkarBloc, AzkarState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.error!, style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context
                        .read<AzkarBloc>()
                        .add(AzkarLoadRequested(widget.type)),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          if (state.items.isEmpty) {
            return Center(
                child: Text('لا توجد أذكار', style: textTheme.bodyMedium));
          }

          return PageView.builder(
            controller: _pageController,
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              final maxCount = item.repeat;
              final current = state.counters[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Text(item.text,
                                style: textTheme.titleMedium,
                                textAlign: TextAlign.center),
                            if ((item.source ?? '').trim().isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Divider(
                                  color: colorScheme.onSurface.withOpacity(0.3),
                                  thickness: 1),
                              const SizedBox(height: 8),
                              Text(item.source!,
                                  style: textTheme.bodySmall?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  textAlign: TextAlign.center),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Divider(
                        color: colorScheme.onSurface.withOpacity(0.3),
                        thickness: 1),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(15)),
                      ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "الذِكر ${index + 1} من ${state.items.length}",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            SizedBox(width: 16), // مسافة أفقية بين العنصر الأول والثاني
                            BlocBuilder<SettingsBloc, SettingsBlocState>(
                              builder: (context, s) => GestureDetector(
                                onTap: () async {
                                  if (current < maxCount) {
                                    final counters = List<int>.from(state.counters);
                                    counters[index] += 1;
                                    context.read<AzkarBloc>().emit(state.copyWith(counters: counters));
                                    await _maybeHaptic(s);
                                    if (counters[index] == maxCount) {
                                      Future.delayed(const Duration(milliseconds: 250), () async {
                                        if (index < state.items.length - 1) {
                                          await _maybeHaptic(s);
                                          _pageController.nextPage(
                                            duration: const Duration(milliseconds: 350),
                                            curve: Curves.easeInOut,
                                          );
                                        } else {
                                          await _maybeHaptic(s);
                                          _showCompletionMessage();
                                        }
                                      });
                                    }
                                  }
                                },
                                onLongPress: () async {
                                  if (current > 0) {
                                    final counters = List<int>.from(state.counters);
                                    counters[index] -= 1;
                                    context.read<AzkarBloc>().emit(state.copyWith(counters: counters));
                                    await _maybeHaptic(s);
                                  }
                                },
                                child: CircularPercentIndicator(
                                  radius: 36,
                                  lineWidth: 6,
                                  percent: (current / maxCount).clamp(0.0, 1.0),
                                  center: Text(
                                    "${current + 1 > maxCount ? maxCount : current + 1}",
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  progressColor: colorScheme.primary,
                                  circularStrokeCap: CircularStrokeCap.round,
                                ),
                              ),
                            ),
                            SizedBox(width: 16), // مسافة أفقية بين العنصر الثاني والثالث
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  maxCount == 1 ? "مرة واحدة" : "التكرار: $maxCount",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        )

                    ),
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
