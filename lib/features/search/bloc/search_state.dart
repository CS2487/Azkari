import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  final String query;
  final List<Map<String, String>> results;

  const SearchState({this.query = '', this.results = const []});

  SearchState copyWith({String? query, List<Map<String, String>>? results}) {
    return SearchState(
        query: query ?? this.query, results: results ?? this.results);
  }

  @override
  List<Object?> get props => [query, results];
}
