import 'package:azkar_application/core/utils/haptics.dart';
import 'package:azkar_application/features/providers/settings_provider.dart';
import 'package:azkar_application/features/screens/sebha/widgets/circular_counter.dart';
import 'package:azkar_application/features/screens/sebha/widgets/dhikr_item.dart';
import 'package:azkar_application/features/screens/sebha/widgets/equal_buttons_row.dart';
import 'package:azkar_application/features/screens/sebha/widgets/primary_big_button.dart';
import 'package:azkar_application/features/screens/sebha/widgets/top_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class SebhaPage extends StatefulWidget {
  const SebhaPage({super.key});

  @override
  State<SebhaPage> createState() => _SebhaPageState();
}

class _SebhaPageState extends State<SebhaPage>
    with SingleTickerProviderStateMixin {
  int counter = 0;
  int goal = 33;

  final List<DhikrItem> adhkar = const [
    DhikrItem(text: 'سبحان الله', defaultGoal: 33),
    DhikrItem(text: 'الحمد لله', defaultGoal: 33),
    DhikrItem(text: 'الله أكبر', defaultGoal: 34),
    DhikrItem(text: 'لا إله إلا الله', defaultGoal: 100),
    DhikrItem(text: 'أستغفر الله', defaultGoal: 100),
  ];
  DhikrItem? selectedDhikr;

  // AnimationController للنبض عند الضغط على زر "تسبيح"
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 140),
    lowerBound: 0.0,
    upperBound: 0.12,
  );

  @override
  void initState() {
    super.initState();
    selectedDhikr = adhkar.first;
    goal = selectedDhikr!.defaultGoal;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _playPulse() async {
    try {
      await _pulseController.forward();
    } finally {
      if (mounted) _pulseController.reverse();
    }
  }

  Future<void> _increment(SettingsProvider settings) async {
    if (!mounted || counter >= goal) return;

    setState(() {
      counter = (counter + 1).clamp(0, goal);
    });

    await _playPulse(); // تشغيل نبض الزر الكبير
    await _maybeHaptic(settings);
  }

  void _resetCounter() {
    setState(() {
      counter = 0;
    });
  }

  double get progress {
    if (goal <= 0) return 0;
    return (counter / goal).clamp(0.0, 1.0);
  }

  Future<void> _maybeHaptic(SettingsProvider settings) async {
    if (!settings.settings.hapticsEnabled) return;
    if (await Vibration.hasVibrator()) {
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

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        final scheme = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: AppBar(
            title: const Text('المسبحة'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _resetCounter,
                tooltip: 'إعادة تسبيح',
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 360;
              final bottomInset = MediaQuery.of(context).viewInsets.bottom;

              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: TopControls(
                            adhkar: adhkar,
                            selectedDhikr: selectedDhikr,
                            goal: goal,
                            onDhikrChanged: (v) {
                              if (v == null) return;
                              setState(() {
                                selectedDhikr = v;
                                goal = v.defaultGoal;
                                counter = 0;
                              });
                            },
                            onGoalChanged: (g) {
                              if (g == goal) return;
                              setState(() {
                                goal = g.clamp(1, 100000);
                                if (counter > goal) counter = 0; // تم التعديل
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: progress),
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return CircularCounter(
                                  progress: value, // نستخدم القيمة المتحركة
                                  count: counter,
                                  goal: goal,
                                  primary: scheme.primary,
                                  surface: scheme.surface,
                                  shadow: scheme.shadow,
                                  onSurfaceVariant: scheme.onSurfaceVariant,
                                  // تم تغيير أسماء الدوال في CircularCounter ليتناسب مع الفصل
                                  onIncrementRequested: () => setState(() {
                                    if (counter < goal) counter++;
                                  }),
                                  onHapticRequested: () =>
                                      _maybeHaptic(settings),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              16, 0, 16, isCompact ? 10 : 18),
                          child: EqualButtonsRow(
                            children: [
                              PrimaryBigButton(
                                label: 'تسبيح',
                                onTap: () => _increment(settings),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
