import '../model/match.dart';

class LoginRequest {
  final String username;
  final String password;

  LoginRequest(this.username, this.password);
}

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