class IncomingMatchesState {
  final dynamic error;
  final bool loading;
  final List<IncomingMatch> data;

  IncomingMatchesState({
    this.error,
    required this.loading,
    required this.data,
  });

  factory IncomingMatchesState.initial() => IncomingMatchesState(
        loading: false,
        data: [],
      );

  IncomingMatchesState copyWith({
    dynamic error,
    bool? loading,
    List<IncomingMatch>? data,
  }) {
    return IncomingMatchesState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      data: data ?? this.data,
    );
  }
}

class IncomingMatch {
  final String matchId;
  final String homeTeamName;
  final String awayTeamName;
  final DateTime when;
  final MatchScore? bet;

  IncomingMatch(
    this.matchId,
    this.homeTeamName,
    this.awayTeamName,
    this.when, [
    this.bet,
  ]);

  factory IncomingMatch.fromJson(Map<String, dynamic> json) => IncomingMatch(
        json["matchId"],
        json["homeTeamName"],
        json["awayTeamName"],
        DateTime.parse(json["when"]),
        _hasBets(json) ? MatchScore.fromJson(json["bets"][0]) : null,
      );

  IncomingMatch copyWith({required MatchScore bet}) {
    return IncomingMatch(matchId, homeTeamName, awayTeamName, when, bet);
  }

  static bool _hasBets(Map<String, dynamic> json) =>
      json["bets"] != null && (json["bets"] as List).isNotEmpty;
}

class MatchScore {
  final int homeTeam;
  final int awayTeam;

  MatchScore(this.homeTeam, this.awayTeam);

  factory MatchScore.fromJson(Map<String, dynamic> json) => MatchScore(
        json["homeTeam"],
        json["awayTeam"],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchScore &&
          runtimeType == other.runtimeType &&
          homeTeam == other.homeTeam &&
          awayTeam == other.awayTeam;

  @override
  int get hashCode => homeTeam.hashCode ^ awayTeam.hashCode;

  @override
  String toString() {
    return 'MatchScore{homeTeam: $homeTeam, awayTeam: $awayTeam}';
  }
}
