import 'package:azkar_application/core/theme/app_constants.dart';
import 'package:azkar_application/core/theme/app_spaces.dart';
import 'package:azkar_application/core/utils/haptics.dart';
import 'package:azkar_application/core/utils/notification_service.dart';
import 'package:azkar_application/features/providers/settings_provider.dart';
import 'package:azkar_application/features/providers/theme_provider.dart';
import 'package:azkar_application/features/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ========================== أدوات مساعدة ==========================

  /// يعرض شريط إشعار مؤقت في الأسفل (SnackBar)
  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000), // زيادة المدة قليلاً
    ));
  }

  /// يعرض منتقي الوقت ويحدث إعدادات التنبيهات.
  Future<void> _pickTime(BuildContext context, String type) async {
    final provider = context.read<SettingsProvider>();
    final s = provider.settings;

    // تحديد الوقت الأولي حسب النوع
    final initial = switch (type) {
      "morning" => s.morningTime,
      "evening" => s.eveningTime,
      "friday" => s.fridayTime,
      _ => TimeOfDay.now(),
    };

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      String message = 'تم ضبط الوقت';
      switch (type) {
        case "morning":
          await provider.pickMorningTime(picked);
          message = 'تم ضبط وقت أذكار الصباح';
          break;
        case "evening":
          await provider.pickEveningTime(picked);
          message = 'تم ضبط وقت أذكار المساء';
          break;
        case "friday":
          await provider.pickFridayTime(picked);
          message = 'تم ضبط وقت تذكير الجمعة';
          break;
      }
      _showSnack(context, message);
    }
  }

  // ========================== عناصر الواجهة (Widgets) ==========================

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    bool? switchValue,
    ValueChanged<bool>? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: switchValue != null
          ? Switch(value: switchValue, onChanged: onSwitchChanged)
          : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap ??
          () {
            if (onSwitchChanged != null) {
              onSwitchChanged(!switchValue!);
            }
          },
    );
  }

  Widget _buildCardSection(Widget child) => Card(child: child);

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpaces.small),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      );

  // ========================== الأقسام الرئيسية ==========================

  Widget _hapticsSection(BuildContext context, SettingsProvider provider) {
    final s = provider.settings;
    final theme = Theme.of(context);

    List<Widget> hapticOptions = [];
    if (s.hapticsEnabled) {
      hapticOptions = HapticStrength.values.map((strength) {
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
            if (val != null) provider.setHapticStrength(val);
          },
        );
      }).toList();
    }

    return _buildCardSection(
      Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: const Text('اهتزاز عند العد/الانتقال'),
            value: s.hapticsEnabled,
            onChanged: provider.toggleHaptics,
          ),
          ...hapticOptions,
        ],
      ),
    );
  }

  Widget _notificationsSection(
      BuildContext context, SettingsProvider provider) {
    return _buildCardSection(
      Column(
        children: [
          // يمكن إزالة هذا ListTile إذا كان يبدو مكرراً
          /*const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('إعدادات التنبيهات'),
          ),*/
          _buildTile(
            icon: Icons.wb_sunny_outlined,
            title: 'أذكار الصباح',
            subtitle: 'الوقت: ${provider.settings.morningTime.format(context)}',
            switchValue: provider.settings.morningOn,
            onSwitchChanged: provider.setMorningOn,
            onTap: () => _pickTime(context, "morning"),
          ),
          _buildTile(
            icon: Icons.nights_stay_outlined,
            title: 'أذكار المساء',
            subtitle: 'الوقت: ${provider.settings.eveningTime.format(context)}',
            switchValue: provider.settings.eveningOn,
            onSwitchChanged: provider.setEveningOn,
            onTap: () => _pickTime(context, "evening"),
          ),
          _buildTile(
            icon: Icons.mosque,
            title: 'تذكير الجمعة',
            subtitle: 'الوقت: ${provider.settings.fridayTime.format(context)}',
            switchValue: provider.settings.fridayOn,
            onSwitchChanged: provider.setFridayOn,
            onTap: () => _pickTime(context, "friday"),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_off),
            title: const Text('إيقاف كل الإشعارات'),
            onTap: () async {
              await NotificationService().cancelAll();
              await provider.disableAllNotifications();
              _showSnack(context, 'تم إيقاف جميع الإشعارات');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeTile(ThemeProvider themeProvider) => Card(
        child: ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('الثيم'),
          subtitle: Text(
            themeProvider.themeMode == ThemeMode.light
                ? 'فاتح (Light)'
                : themeProvider.themeMode == ThemeMode.dark
                    ? 'داكن (Dark)'
                    : 'حسب النظام (System)',
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showThemeDialog(themeProvider),
        ),
      );

  Widget _buildAboutTile() => Card(
        child: ListTile(
          leading: const Icon(Icons.info),
          title: const Text('حول التطبيق'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showAboutDialog,
        ),
      );

  Widget _buildDeveloperInfo() => Card(
        child: ListTile(
          leading: const Icon(Icons.person),
          title: const Text('مطور التطبيق'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showDeveloperInfoDialog,
        ),
      );

  Widget _buildAppInfo() => Center(
        child: Padding(
          padding: const EdgeInsets.only(
              top: AppSpaces.small, bottom: AppSpaces.medium),
          child: Column(
            children: [
              const Icon(Icons.menu_book, size: 48),
              AppSpaces.gapSmall,
              Text(
                AppConstants.appName,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              AppSpaces.gapSmall,
              const Text('الإصدار ${AppConstants.appVersion}'),
            ],
          ),
        ),
      );

  // ========================== صناديق الحوار (Dialogs) ==========================

  void _showThemeDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('اختر الثيم')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var mode in [
              ThemeMode.light,
              ThemeMode.dark,
              ThemeMode.system
            ])
              RadioListTile<ThemeMode>(
                title: Text(mode.name == 'light'
                    ? 'فاتح'
                    : mode.name == 'dark'
                        ? 'داكن'
                        : 'حسب النظام'),
                value: mode,
                groupValue: themeProvider.themeMode,
                onChanged: (m) {
                  if (m != null) themeProvider.setThemeMode(m);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() => showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Center(child: Text('حول التطبيق')),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تطبيق أذكاري هو رفيقك اليومي للأذكار والأدعية.',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'يوفر لك التطبيق:\n'
                  '1. جميع اذكار المسلم\n'
                  '2. واجهة سهلة وبسيطة\n'
                  '3. مسبحة الكترونية \n'
                  '4. دعم الوضع الليلي والنهاري\n',
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildDeveloperInfoContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.code,
            size: 50,
          ),
          Text(
            'مطور التطبيق',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          AppSpaces.gapSmall,
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'للتواصل والاستفسار:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('فارع الضلاع'),
          const Text('farea2487@gmail.com'),
          const Text('717-281-413'),
        ],
      ),
    );
  }

  void _showDeveloperInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('معلومات المطور')),
        content: _buildDeveloperInfoContent(context),
      ),
    );
  }

  // ========================== Build ==========================
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'الإعدادات',
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpaces.small),
        children: [
          _sectionHeader('الإعدادات العامة'),
          _buildThemeTile(themeProvider),
          // _languageTile(localeProvider), // غير مفعل
          _sectionHeader('الهزاز'),
          _hapticsSection(context, settingsProvider),
          _sectionHeader('التنبيهات'),
          _notificationsSection(context, settingsProvider),
          _sectionHeader('معلومات إضافية'),
          _buildAboutTile(),
          const SizedBox(height: AppSpaces.small),
          _buildDeveloperInfo(),
          _buildAppInfo(),
        ],
      ),
    );
  }
}
