import '../model/match.dart';

class ChangeBetAction {
  final String matchId;
  final MatchScore bet;

  ChangeBetAction(this.matchId, this.bet);
}

class ResetBetsAction {}

class SaveBetsAction {}