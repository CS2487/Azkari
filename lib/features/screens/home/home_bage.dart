import 'dart:convert';
import 'package:azkar_application/features/providers/search_provider.dart';
import 'package:azkar_application/features/screens/azkar/widgets/azkar_list_view.dart';
import 'package:azkar_application/features/screens/search/azkar_search_delegate.dart';
import 'package:azkar_application/features/screens/settings/settings_page.dart';
import 'package:azkar_application/features/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _loadCachedAzkar();
  }

  Future<void> _loadCachedAzkar() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('adhkar_cache');

    List<Map<String, dynamic>> loadedItems;

    if (cachedData != null) {
      final data = jsonDecode(cachedData) as List;
      loadedItems = data
          .map((e) => {
                "title": e["category"] as String,
                "type": e["category"],
              })
          .toList();
    } else {
      final String response =
          await rootBundle.loadString('assets/json/adhkar.json');
      await prefs.setString('adhkar_cache', response);
      final data = jsonDecode(response) as List;
      loadedItems = data
          .map((e) => {
                "title": e["category"] as String,
                "type": e["category"],
              })
          .toList();
    }

    if (mounted) {
      setState(() {
        items = loadedItems;
      });

      // ربط البيانات مع SearchProvider
      final searchProvider = context.read<SearchProvider>();
      searchProvider.setItems(items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
          icon: const Icon(Icons.notifications_active_outlined, size: 26),
        ),
        title: 'الأذكار',
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 26),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AzkarSearchPage()),
            ),
          ),
        ],
      ),
      body: items.isEmpty
          ? Container() // لا لود، الصفحة فارغة أولاً فقط
          : AzkarListView(items: items),
    );
  }
}
