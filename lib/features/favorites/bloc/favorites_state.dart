import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  final List<Map<String, String>> favorites;
  const FavoritesState(this.favorites);

  bool isFavoriteType(String type) => favorites.any((e) => e['type'] == type);

  @override
  List<Object?> get props => [favorites];
}
