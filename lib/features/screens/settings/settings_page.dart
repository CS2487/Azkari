import 'package:azkar_application/core/theme/app_constants.dart';
import 'package:azkar_application/core/theme/app_spaces.dart';
import 'package:azkar_application/core/utils/haptics.dart';
import 'package:azkar_application/core/utils/notification_service.dart';
import 'package:azkar_application/features/providers/locale_provider.dart';
import 'package:azkar_application/features/providers/settings_provider.dart';
import 'package:azkar_application/features/providers/theme_provider.dart';
import 'package:azkar_application/features/widgets/custom_appbar.dart';
import 'package:azkar_application/features/widgets/logout_dialog.dart';
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
    _loadSettings();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    )..forward();
  }

  Future<void> _loadSettings() async {
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ========================== التنبيهات ==========================
  Future<void> _pickTime(BuildContext context, String type) async {
    final provider = context.read<SettingsProvider>();
    final s = provider.settings;
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
          await provider.pickMorningTime(picked);
          _showSnack(context, 'تم ضبط وقت أذكار الصباح');
          break;
        case "evening":
          await provider.pickEveningTime(picked);
          _showSnack(context, 'تم ضبط وقت أذكار المساء');
          break;
        case "friday":
          await provider.pickFridayTime(picked);
          _showSnack(context, 'تم ضبط وقت تذكير الجمعة');
          break;
      }
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 250),
    ));
  }

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
      onTap: onTap,
    );
  }

  Widget _buildCardSection(Widget child) => Card(child: child);

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
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('التنبيهات'),
          ),
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

  Widget _themeTile(ThemeProvider themeProvider) => Card(
        child: ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('الثيم'),
          subtitle: Text(
            themeProvider.themeMode == ThemeMode.light
                ? 'Light'
                : themeProvider.themeMode == ThemeMode.dark
                    ? 'Dark'
                    : 'System',
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showThemeDialog(themeProvider),
        ),
      );

  Widget _languageTile(LocaleProvider localeProvider) => Card(
        child: ListTile(
          leading: const Icon(Icons.language),
          title: const Text('اللغة'),
          subtitle: Text(localeProvider.isArabic ? 'العربية' : 'English'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showLanguageDialog(localeProvider),
        ),
      );

  Widget _aboutTile() => Card(
        child: ListTile(
          leading: const Icon(Icons.info),
          title: const Text('حول التطبيق'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showAbout,
        ),
      );

  Widget _appInfo() => Center(
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
      );

  void _logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LogoutDialog(),
    );
  }

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
                title: Text(mode.name),
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

  void _showLanguageDialog(LocaleProvider localeProvider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('اختر اللغة')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                localeProvider.setLocale(const Locale('en', 'US'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                localeProvider.setLocale(const Locale('ar', 'AE'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAbout() => showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Center(child: Text('حول التطبيق')),
          content: Text(
            '${AppConstants.appName}\n'
            'الإصدار: ${AppConstants.appVersion}\n\n'
            'تطبيق أذكاري هو رفيقك اليومي للأذكار والأدعية.\n'
            'يوفر لك التطبيق:\n'
            '• جميع اذكار المسلم\n'
            '• أذكار متنوعة من السنة النبوية\n'
            '• واجهة سهلة وبسيطة\n'
            '• دعم لغات العربية والانجليزية\n'
            '• دعم الوضع الليلي والنهاري\n',
          ),
        ),
      );

  // ========================== Build ==========================
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'الأعدادات',
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpaces.small),
        children: [
          _sectionHeader('الإعدادات العامة'),
          _themeTile(themeProvider),
         // _languageTile(localeProvider),
          _sectionHeader('الهزاز'),
          _hapticsSection(context, settingsProvider),
          _sectionHeader('التنبيهات'),
          _notificationsSection(context, settingsProvider),
          _sectionHeader('معلومات'),
          _aboutTile(),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الخروج'),
              onTap: () => _logoutDialog(context),
            ),
          ),
          const SizedBox(height: 8),
          _appInfo(),
        ],
      ),
    );
  }
}
