import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../favorites/bloc/favorites_bloc.dart';
import '../../../favorites/bloc/favorites_state.dart';
import '../../../favorites/bloc/favorites_event.dart';
import '../../presentation/pages/azkar_page.dart';
import 'azkar_card.dart';

class AzkarListView extends StatelessWidget {
  final List<Map<String, String>> items;
  const AzkarListView({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favs) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12), // مسافة خارجية عامة
          itemCount: items.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: 8), // مسافة بين البطاقات
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
                MaterialPageRoute(builder: (_) => AzkarPage(type: type)),
              ),
              onFavoriteToggle: () =>
                  context.read<FavoritesBloc>().add(FavoriteToggled(item)),
            );
          },
        );
      },
    );
  }
}
