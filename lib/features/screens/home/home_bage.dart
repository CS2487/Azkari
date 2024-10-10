import 'package:azkar_application/features/azkar/presentation/widgets/azkar_list_view.dart';
import 'package:azkar_application/features/search/presentation/azkar_search_delegate.dart';
import 'package:azkar_application/features/settings/presentation/settings_page.dart';
import 'package:azkar_application/main.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {"title": "أذكار الصباح ", "type": "morning"},
      {"title": "أذكار المساء ", "type": "evening"},
      {"title": "أذكار بعد الصلاة ", "type": "prayer"},
      {"title": "أذكار بعد الصلاة3 ", "type": "prayer3"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsPage()),
            );
          },
          icon: const Icon(Icons.notifications_active_outlined, size: 26),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 26),
            onPressed: () => showSearch(
              context: context,
              delegate: AzkarSearchDelegate(),
            ),
          ),
        ],
      ),
      body: AzkarListView(items: items),
    );
  }
}
