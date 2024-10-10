import 'package:azkar_application/data/models/azkar_entry.dart';
import 'package:equatable/equatable.dart';

class AzkarState extends Equatable {
  final bool loading;
  final String? error;
  final List<Azkar> items;
  final List<int> counters;

  const AzkarState({
    required this.loading,
    this.error,
    this.items = const [],
    this.counters = const [],
  });

  AzkarState copyWith({
    bool? loading,
    String? error,
    List<Azkar>? items,
    List<int>? counters,
  }) {
    return AzkarState(
      loading: loading ?? this.loading,
      error: error,
      items: items ?? this.items,
      counters: counters ?? this.counters,
    );
  }

  @override
  List<Object?> get props => [loading, error, items, counters];
}
