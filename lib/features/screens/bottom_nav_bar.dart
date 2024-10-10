import 'package:azkar_application/features/screens/sebha/sebha_page.dart';
import 'package:azkar_application/features/screens/favorites/favorites_page.dart';
import 'package:azkar_application/features/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';

import 'home/home_bage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const SebhaPage(),
    const FavoritePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement), label: 'المسبحة'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'المفضلة'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}

/*
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أذكاري'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ArbaeenPage()),
                  );
                },
                child: const Card(
                  child: Center(
                      child: Text(
                        'الأربعين النووية',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SpecialDuasPage()),
                  );
                },
                child: const Card(
                  child: Center(
                      child: Text(
                        'أدعية خاصة',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  const AzkarMuslimPage()),
                  );
                },
                child: const Card(
                  child: Center(
                      child: Text(
                        'أذكار المسلم',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ArbaeenPage extends StatelessWidget {
  const ArbaeenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class SpecialDuasPage extends StatelessWidget {
  const SpecialDuasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
*/
