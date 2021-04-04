class IncomingMatch {
  final String matchId;
  final String homeTeamName;
  final String awayTeamName;
  final DateTime when;
  final MatchScore? bet;

  IncomingMatch(this.matchId, this.homeTeamName, this.awayTeamName, this.when, [this.bet]);
}

class MatchScore {
  final int homeTeam;
  final int awayTeam;

  MatchScore(this.homeTeam, this.awayTeam);

  @override
  String toString() {
    return 'MatchScore{homeTeam: $homeTeam, awayTeam: $awayTeam}';
  }
}