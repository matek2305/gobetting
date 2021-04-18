import '../matches/model.dart';

class UnsavedBetsState {
  final dynamic error;
  final bool saving;
  final Map<String, MatchScore> data;

  UnsavedBetsState({
    this.error,
    required this.saving,
    required this.data,
  });

  factory UnsavedBetsState.initial() => UnsavedBetsState(
    saving: false,
    data: {},
  );

  UnsavedBetsState copyWith({
    dynamic error,
    bool? saving,
    Map<String, MatchScore>? data,
  }) {
    return UnsavedBetsState(
      error: error ?? this.error,
      saving: saving ?? this.saving,
      data: data ?? this.data,
    );
  }
}