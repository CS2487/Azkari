import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchQueryChanged>(_onQuery);
  }

  final List<Map<String, String>> allAzkar = const [
    {"text": "أذكار الصباح", "type": "morning"},
    {"text": "أذكار المساء", "type": "evening"},
    {"text": "أذكار النوم", "type": "sleep"},
    {"text": "أذكار بعد الصلاة", "type": "prayer"},
    {"text": "أذكار دخول/خروج المسجد", "type": "masjid"},
    {"text": "دعاء دخول الخلاء", "type": "enter_toilet"},
    {"text": "دعاء الخروج من الخلاء", "type": "exit_toilet"},
    {"text": "دعاء قبل الوضوء", "type": "pre_wudu"},
    {"text": "دعاء بعد الوضوء", "type": "post_wudu"},
    {"text": "دعاء الخروج من المنزل", "type": "leave_home"},
    {"text": "دعاء دخول المنزل", "type": "enter_home"},
    {"text": "دعاء الذهاب إلى المسجد", "type": "going_mosque"},
    {"text": "دعاء دخول المسجد", "type": "enter_mosque"},
    {"text": "دعاء الخروج من المسجد", "type": "exit_mosque"},







  ];

  void _onQuery(SearchQueryChanged e, Emitter<SearchState> emit) {
    final q = e.query;
    final results = allAzkar.where((a) => a["text"]!.contains(q)).toList();
    emit(state.copyWith(query: q, results: results));
  }
}
