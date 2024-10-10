import 'package:azkar_application/core/utils/haptics.dart';
import 'package:azkar_application/core/utils/notification_service.dart';
import 'package:azkar_application/features/widgets/logout_dialog.dart';
import 'package:azkar_application/features/settings/Provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});
//
//   Future<void> _pickTime(BuildContext context, String type) async {
//     final provider = context.read<SettingsProvider>();
//     final s = provider.settings;
//     final initial = switch (type) {
//       "morning" => s.morningTime,
//       "evening" => s.eveningTime,
//       "friday" => s.fridayTime,
//       _ => TimeOfDay.now(),
//     };
//
//     final picked = await showTimePicker(context: context, initialTime: initial);
//     if (picked != null) {
//       switch (type) {
//         case "morning":
//           await provider.pickMorningTime(picked);
//           _showSnack(context, 'تم ضبط وقت أذكار الصباح');
//           break;
//         case "evening":
//           await provider.pickEveningTime(picked);
//           _showSnack(context, 'تم ضبط وقت أذكار المساء');
//           break;
//         case "friday":
//           await provider.pickFridayTime(picked);
//           _showSnack(context, 'تم ضبط وقت تذكير الجمعة');
//           break;
//       }
//     }
//   }
//
//   void _showSnack(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   Widget _buildTile({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     bool? switchValue,
//     ValueChanged<bool>? onSwitchChanged,
//     VoidCallback? onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       subtitle: subtitle != null ? Text(subtitle) : null,
//       trailing: switchValue != null
//           ? Switch(value: switchValue, onChanged: onSwitchChanged)
//           : null,
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildCardExpansion({
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//     bool initiallyExpanded = false,
//   }) {
//     return Card(
//       //scolor: const Color(0xFF393939),
//       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       // elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       child: ExpansionTile(
//         title: Text(title),
//         leading: Icon(icon),
//         initiallyExpanded: initiallyExpanded,
//         children: children,
//       ),
//     );
//   }
//
//   Widget _hapticsSection(BuildContext context, SettingsProvider provider) {
//     final s = provider.settings;
//     final theme = Theme.of(context);
//
//     List<Widget> hapticOptions = [];
//     if (s.hapticsEnabled) {
//       hapticOptions = HapticStrength.values.map((strength) {
//         final title = switch (strength) {
//           HapticStrength.light => "خفيف",
//           HapticStrength.medium => "متوسط",
//           HapticStrength.strong => "قوي",
//         };
//         return RadioListTile<HapticStrength>(
//           title: Text(title, style: theme.textTheme.bodyMedium),
//           value: strength,
//           groupValue: s.hapticStrength,
//           onChanged: (val) {
//             if (val != null) provider.setHapticStrength(val);
//           },
//         );
//       }).toList();
//     }
//
//     return Column(
//       children: [
//         _buildTile(
//           icon: Icons.vibration,
//           title: 'اهتزاز عند العد/الانتقال',
//           switchValue: s.hapticsEnabled,
//           onSwitchChanged: provider.toggleHaptics,
//         ),
//         ...hapticOptions,
//       ],
//     );
//   }
//
//   Widget _notificationsSection(BuildContext context, SettingsProvider provider) {
//     return _buildCardExpansion(
//       title: 'التنبيهات',
//       icon: Icons.notifications,
//       initiallyExpanded: false,
//       children: [
//         _buildTile(
//           icon: Icons.wb_sunny_outlined,
//           title: 'أذكار الصباح',
//           subtitle: 'الوقت: ${provider.settings.morningTime.format(context)}',
//           switchValue: provider.settings.morningOn,
//           onSwitchChanged: provider.setMorningOn,
//           onTap: () => _pickTime(context, "morning"),
//         ),
//         _buildTile(
//           icon: Icons.nights_stay_outlined,
//           title: 'أذكار المساء',
//           subtitle: 'الوقت: ${provider.settings.eveningTime.format(context)}',
//           switchValue: provider.settings.eveningOn,
//           onSwitchChanged: provider.setEveningOn,
//           onTap: () => _pickTime(context, "evening"),
//         ),
//         _buildTile(
//           icon: Icons.mosque,
//           title: 'تذكير الجمعة',
//           subtitle: 'الوقت: ${provider.settings.fridayTime.format(context)}',
//           switchValue: provider.settings.fridayOn,
//           onSwitchChanged: provider.setFridayOn,
//           onTap: () => _pickTime(context, "friday"),
//         ),
//         _buildTile(
//           icon: Icons.notifications_off,
//           title: 'إيقاف كل الإشعارات',
//           onTap: () async {
//             await NotificationService().cancelAll();
//             await provider.disableAllNotifications();
//             _showSnack(context, 'تم إيقاف جميع الإشعارات');
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _generalSettingsSection(BuildContext context, SettingsProvider provider) {
//     return _buildCardExpansion(
//       title: 'الإعدادات العامة',
//       icon: Icons.settings,
//       initiallyExpanded: false,
//       children: [_hapticsSection(context, provider)],
//     );
//   }
//
//   Widget _infoSection(BuildContext context) {
//     return Card(
//
//       margin: const EdgeInsets.symmetric(vertical: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: const [
//             Icon(Icons.menu_book, size: 48),
//             SizedBox(height: 8),
//             Text(
//               'أذكاري',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             SizedBox(height: 4),
//             Text('الإصدار 1.0.0'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<SettingsProvider>(
//       builder: (context, provider, _) {
//         return Scaffold(
//           appBar: AppBar(title: const Text('الإعدادات'), centerTitle: true),
//           body: ListView(
//             padding: const EdgeInsets.all(12),
//             physics: const BouncingScrollPhysics(),
//             children: [
//               _generalSettingsSection(context, provider),
//               _notificationsSection(context, provider),
//               _infoSection(context),
//             ],
//           ),
//
//         );
//       },
//     );
//   }
// }
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  String _defaultCurrency = AppConstants.defaultCurrency;
  bool _showNotifications = true;
  late AnimationController _animationController;
  static bool isDarkMode = false;
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
    );
    _animationController.forward();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _defaultCurrency =
          prefs.getString('defaultCurrency') ?? AppConstants.defaultCurrency;
      _showNotifications = prefs.getBool('showNotifications') ?? true;
    });
  }

  Future<void> _saveDefaultCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultCurrency', currency);
    setState(() => _defaultCurrency = currency);
  }

  Future<void> _saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showNotifications', value);
    setState(() => _showNotifications = value);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    bool isDarkMode = false;
    return Scaffold(
      appBar: AppBar(title: Text('الإعدادات', style: textTheme.titleLarge)),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(AppSpaces.small),
        children: [
          _sectionHeader('الإعدادات العامة'),

          _themeTile(themeProvider),

          _languageTile(localeProvider),

          _notificationsTile(),


          _sectionHeader('معلومات'),
          _aboutTile(),

          _helpTile(),

          _supportTile(),

          _sectionCard(Column(
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('تسجيل الخروج'),
                onTap: () => _logoutDialog(context),
              ),
            ],
          )),

          _appInfo(),

        ],
      ),
    );
  }

  // ===== Widgets =====
  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpaces.small),
    child: Text(title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold)),
  );

  Widget _sectionCard(Widget child) => Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: child,
  );

  Widget _themeTile(ThemeProvider themeProvider) => Card(
    child: ListTile(
      leading: const Icon(Icons.dark_mode),
      title: const Text('الثيم'),
      subtitle: Text(themeProvider.themeMode == ThemeMode.light
          ? 'Light'
          : themeProvider.themeMode == ThemeMode.dark
          ? 'Dark'
          : 'System'),
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

  Widget _notificationsTile() => Card(
    child: SwitchListTile(
      secondary: const Icon(Icons.notifications),
      title: const Text('الإشعارات'),
      subtitle: const Text('تفعيل إشعارات التطبيق'),
      value: _showNotifications,
      onChanged: _saveNotifications,
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

  Widget _helpTile() => Card(
    child: ListTile(
      leading: const Icon(Icons.help),
      title: const Text('المساعدة'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: _showHelp,
    ),
  );
  Widget _supportTile() => Card(
    child: ListTile(
      leading: const Icon(Icons.support_agent),
      title: const Text('الدعم الفني'),
      subtitle: const Text('تواصل معنا لحل مشاكلك'),
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.chat, color: Colors.green),
                title: const Text("واتساب"),
                onTap: () async {
                  final msg =
                  Uri.encodeComponent("مرحبًا، اود الاستفسار...");
                  final uri =
                  Uri.parse("https://wa.me/967717281413?text=$msg");
                  await launchUrl(uri,
                      mode: LaunchMode.externalApplication);
                },
              ),
              ListTile(
                leading: const Icon(Icons.call, color: Colors.blue),
                title: const Text("اتصال هاتفي"),
                onTap: () async {
                  final uri = Uri.parse("tel:+967717281413");
                  await launchUrl(uri);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.chat,
                ),
                title: const Text("رسالة SMS"),
                onTap: () async {
                  final uri = Uri.parse(
                      "sms:+967717281413?body=${Uri.encodeComponent("مرحبًا، احتاج مساعدة")}");
                  await launchUrl(uri);
                },
              ),
            ],
          ),
        );
      },
    ),
  );

  Widget _appInfo() => Center(
    child: Column(
      children: [
        const Icon(Icons.account_balance_wallet, size: 48),
        AppSpaces.gapSmall,
        Text(AppConstants.appName,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
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

  void _selectCurrency() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('اختر العملة الافتراضية')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.currencies.map((currency) {
            return RadioListTile<String>(
              title: Text(currency),
              value: currency,
              groupValue: _defaultCurrency,
              onChanged: (value) {
                if (value != null) _saveDefaultCurrency(value);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
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

  void _showHelp() => showDialog(
    context: context,
    builder: (_) => const AlertDialog(
      title: Center(child: Text('المساعدة')),
      content: Text(
        'كيفية استخدام التطبيق:\n\n'
            '1. أضف عميل جديد من الشاشة الرئيسية\n'
            '2. اضغط على العميل لإدارة معاملاته\n'
            '3. أضف معاملة جديدة (لك/عليك)\n'
            '4. استخدم القائمة لتعديل أو حذف أو طباعة\n'
            '5. استخدم البحث للعثور على العملاء أو المعاملات',
      ),
    ),
  );

  void _showAbout() => showDialog(
    context: context,
    builder: (_) => const AlertDialog(
      title: Center(child: Text('حول التطبيق')),
      content: Text(
        '${AppConstants.appName}\n'
            'الإصدار: ${AppConstants.appVersion}\n\n'
            'تطبيق لإدارة العملاء والمعاملات المالية\n'
            'يوفر التطبيق:\n'
            '• إدارة العملاء\n'
            '• تتبع المعاملات المالية\n'
            '• طباعة الإيصالات\n'
            '• تقارير مالية\n'
            '• نسخ احتياطي للبيانات',
      ),
    ),
  );

}