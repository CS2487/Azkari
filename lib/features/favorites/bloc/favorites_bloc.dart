import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState([])) {
    on<FavoriteToggled>(_onToggle);
  }

  void _onToggle(FavoriteToggled e, Emitter<FavoritesState> emit) {
    final list = List<Map<String, String>>.from(state.favorites);
    final type = e.item['type'];
    if (type == null) return;
    final index = list.indexWhere((x) => x['type'] == type);
    if (index >= 0) {
      list.removeAt(index);
    } else {
      list.add(e.item);
    }
    emit(FavoritesState(list));
  }
}
