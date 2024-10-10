import 'package:azkar_application/features/azkar/presentation/widgets/azkar_list_view.dart';
import 'package:azkar_application/features/favorites/provider/FavoritesProvider.dart';
import 'package:azkar_application/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favs, _) {
        final favorites = favs.favorites;
        return Scaffold(
          appBar: AppBar(title: const Text("المفضلة")),
          body: favorites.isEmpty
              ? const Center(child: Text("لا توجد عناصر مفضلة"))
              : AzkarListView(items: favorites),
        );
      },
    );
  }
}
