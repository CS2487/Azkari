import 'package:azkar_application/data/repositories/azkar_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'azkar_event.dart';
import 'azkar_state.dart';

class AzkarBloc extends Bloc<AzkarEvent, AzkarState> {
  AzkarBloc(this.repo)
      : super(const AzkarState(loading: false, items: [], counters: [])) {
    on<AzkarLoadRequested>(_onLoad);
  }

  final AzkarRepository repo;

  Future<void> _onLoad(AzkarLoadRequested e, Emitter<AzkarState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final list = await repo.loadByType(e.type);
      emit(AzkarState(
          loading: false, items: list, counters: List.filled(list.length, 0)));
    } catch (_) {
      emit(
          state.copyWith(loading: false, error: 'حصل خطأ أثناء تحميل الأذكار'));
    }
  }
}
