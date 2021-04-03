class MatchScore {
  final int homeTeam;
  final int awayTeam;

  MatchScore(this.homeTeam, this.awayTeam);

  @override
  String toString() {
    return 'MatchScore{homeTeam: $homeTeam, awayTeam: $awayTeam}';
  }
}