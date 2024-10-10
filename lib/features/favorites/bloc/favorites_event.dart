import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteToggled extends FavoritesEvent {
  final Map<String, String> item; // {"title":..., "type":...}
  FavoriteToggled(this.item);
  @override
  List<Object?> get props => [item];
}
