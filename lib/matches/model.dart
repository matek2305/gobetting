class IncomingMatchesState {
  final dynamic error;
  final bool loading;
  final List<IncomingMatch> incomingMatches;
  final Map<String, MatchScore> unsavedBets;

  IncomingMatchesState({
    this.error,
    required this.loading,
    required this.incomingMatches,
    required this.unsavedBets,
  });

  factory IncomingMatchesState.initial() => IncomingMatchesState(
        loading: false,
        incomingMatches: [],
        unsavedBets: {},
      );

  IncomingMatchesState copyWith({
    dynamic error,
    bool? loading,
    List<IncomingMatch>? incomingMatches,
    Map<String, MatchScore>? unsavedBets,
  }) {
    return IncomingMatchesState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      incomingMatches: incomingMatches ?? this.incomingMatches,
      unsavedBets: unsavedBets ?? this.unsavedBets,
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
        json["bet"] != null ? MatchScore.fromJson(json["bet"]) : null,
      );

  IncomingMatch copyWith({required MatchScore bet}) {
    return IncomingMatch(matchId, homeTeamName, awayTeamName, when, bet);
  }
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
