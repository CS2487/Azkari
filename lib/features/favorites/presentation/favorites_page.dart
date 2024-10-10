import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_state.dart';
import '../../azkar/presentation/widgets/azkar_list_view.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favs) {
        final favorites = favs.favorites;
        return Scaffold(
          appBar: AppBar(title: const Text("المفضلة")),
          body: favorites.isEmpty
              ? const Center(child: Text("لا توجد عناصر مفضلة"))
              : AzkarListView(
            items: favorites,
          ),
        );

      },
    );
  }
}
