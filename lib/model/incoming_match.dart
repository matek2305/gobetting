import './match_score.dart';

class IncomingMatch {
  final String matchId;
  final String homeTeamName;
  final String awayTeamName;
  final DateTime when;
  final MatchScore? bet;

  IncomingMatch(this.matchId, this.homeTeamName, this.awayTeamName, this.when, [this.bet]);
}