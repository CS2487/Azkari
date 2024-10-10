import 'package:equatable/equatable.dart';

abstract class AzkarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AzkarLoadRequested extends AzkarEvent {
  final String type;
  AzkarLoadRequested(this.type);
  @override
  List<Object?> get props => [type];
}
