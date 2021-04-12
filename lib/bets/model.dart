class IncomingMatch {
  final String matchId;
  final String homeTeamName;
  final String awayTeamName;
  final DateTime when;
  final MatchScore? bet;

  IncomingMatch(this.matchId, this.homeTeamName, this.awayTeamName, this.when, [this.bet]);

  IncomingMatch copyWith({required MatchScore bet}) {
    return IncomingMatch(matchId, homeTeamName, awayTeamName, when, bet);
  }
}

class MatchScore {
  final int homeTeam;
  final int awayTeam;

  MatchScore(this.homeTeam, this.awayTeam);

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