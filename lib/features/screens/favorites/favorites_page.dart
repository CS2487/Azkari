import 'package:azkar_application/features/providers/favorites_provider.dart';
import 'package:azkar_application/features/screens/azkar/widgets/azkar_list_view.dart';
import 'package:azkar_application/features/widgets/custom_appbar.dart';
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
          appBar: const CustomAppBar(
            title: 'المفضلة',
          ),
          body: favorites.isEmpty
              ? const Center(child: Text("لا توجد عناصر مفضلة"))
              : AzkarListView(items: favorites),
        );
      },
    );
  }
}
