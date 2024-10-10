import 'package:azkar_application/core/utils/haptics.dart';
import 'package:azkar_application/core/utils/notification_service.dart';
import 'package:azkar_application/features/data/models/azkar_entry.dart';
import 'package:azkar_application/features/providers/adhkar_provider.dart';
import 'package:azkar_application/features/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class AzkarPage extends StatefulWidget {
  final String type;
  final String title;

  const AzkarPage({super.key, required this.type, required this.title});

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
      context.read<AzkarProvider>().load(widget.type);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  void _showCompletionMessage() {
    Fluttertoast.showToast(
      msg: '✅جزاك الله خير تم الانتهاء من ذكر ${widget.title}',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      fontSize: 18.0,
    );
  }

  Future<void> _pickTimeAndSchedule(BuildContext context) async {
    final settingsProvider = context.read<SettingsProvider>();
    final initialTime = settingsProvider.settings.morningTime; // مبدئيًا أي وقت

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final int notificationId = widget.title.hashCode;
      await NotificationService().cancelNotification(notificationId);
      await NotificationService().scheduleDailyNotification(
        id: notificationId,
        title: widget.title,
        body: "حان وقت قراءة ${widget.title}",
        hour: picked.hour,
        minute: picked.minute,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم ضبط وقت ${widget.title}"),
          duration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  // void _cancelNotification() async {
  //   // نستخدم نفس المعرّف (ID) الذي استخدمناه لجدولة التنبيه
  //   final int notificationId = widget.title.hashCode;
  //
  //   // إلغاء التنبيه
  //   await NotificationService().cancelNotification(notificationId);
  //
  //   if (!mounted) return;
  //
  //   // إظهار رسالة تأكيد للمستخدم
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("✅ تم إيقاف التنبيه اليومي لـ ${widget.title}"),
  //       duration: const Duration(milliseconds: 1500),
  //     ),
  //   );
  // }
  void _shareCurrent(List<ZikrItem> list) {
    final page =
        _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;
    if (list.isEmpty) return;
    final index = page.clamp(0, list.length - 1);
    final item = list[index];
    final src = (item.source == null || item.source!.trim().isEmpty)
        ? ''
        : '\n [${item.source}]';

    Share.share(
      'من ${widget.title}\n${item.text}$src\n التكرار: ${item.count}',
      subject: widget.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<AzkarProvider>(
            builder: (context, azkar, _) => IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareCurrent(azkar.flatList),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.access_alarm),
            onPressed: () => _pickTimeAndSchedule(context),
          ),
          // IconButton(
          //   icon: const Icon(Icons.alarm_off),
          //   onPressed: _cancelNotification,
          //   tooltip: 'إيقاف التنبيه اليومي',
          // ),
        ],
      ),
      body: Consumer<AzkarProvider>(
        builder: (context, azkar, _) {
          if (azkar.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (azkar.error != null) {
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
          }
          if (azkar.flatList.isEmpty) {
            return const Center(child: Text(' لا توجد أذكار متاحة'));
          }

          return PageView.builder(
            controller: _pageController,
            itemCount: azkar.flatList.length,
            itemBuilder: (context, index) {
              final item = azkar.flatList[index];
              final current = azkar.counters[index];
              final maxCount = item.count;

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Container(
                          width: double.infinity, // ✅ يملأ العرض بالكامل
                          constraints: const BoxConstraints(
                              minHeight: 200), // ✅ حد أدنى للارتفاع
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontSize: 18,
                                        height: 1.6,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                if ((item.source ?? '').trim().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      item.source!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "الذِكر ${index + 1} من ${azkar.flatList.length}",
                              style: Theme.of(context).textTheme.bodyMedium),
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
                              radius: 42,
                              lineWidth: 7,
                              percent: (current / maxCount).clamp(0.0, 1.0),
                              center: Text(
                                "${current + 1 > maxCount ? maxCount : current + 1}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              progressColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.grey[200]!,
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                          ),
                          Text(
                            maxCount == 1 ? "مرة واحدة" : " التكرار: $maxCount",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
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
