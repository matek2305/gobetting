import 'model.dart';

class ChangeBetAction {
  final String matchId;
  final MatchScore bet;

  ChangeBetAction(this.matchId, this.bet);
}

class ResetBetsAction {}

class ResetBetAction {
  final String matchId;

  ResetBetAction(this.matchId);
}

class SaveBetsAction {
  final Map<String, MatchScore> bets;

  SaveBetsAction(this.bets);
}