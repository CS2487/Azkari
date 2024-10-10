import 'package:azkar_application/features/providers/favorites_provider.dart';
import 'package:azkar_application/features/screens/azkar/azkar_page.dart';
import 'package:azkar_application/features/screens/azkar/widgets/azkar_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AzkarListView extends StatelessWidget {
  final List<Map<String, dynamic>> items;   // بدل String
  const AzkarListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favs, _) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            final type = item['type'] ?? '';
            final isFavorite = favs.isFavoriteType(type);

            return AzkarCard(
              title: item['title'] ?? '',
              type: type,
              isFavorite: isFavorite,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AzkarPage(
                    title: item['title'] ?? '',
                    type: type,
                  ),
                ),
              ),
              onFavoriteToggle: () => favs.toggleFavorite(item),
            );
          },
        );
      },
    );
  }
}
