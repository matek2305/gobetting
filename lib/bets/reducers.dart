import 'package:redux/redux.dart';

import 'actions.dart';
import 'model.dart';

final incomingMatchesReducer = combineReducers<List<IncomingMatch>>([
  TypedReducer<List<IncomingMatch>, SaveBetsAction>(_saveBets),
]);

List<IncomingMatch> _saveBets(
  List<IncomingMatch> matches,
  SaveBetsAction action,
) {
  return matches
      .map((match) => action.bets.containsKey(match.matchId)
          ? match.copyWith(bet: action.bets[match.matchId]!)
          : match)
      .toList();
}

final unsavedBetsReducer = combineReducers<Map<String, MatchScore>>([
  TypedReducer<Map<String, MatchScore>, ChangeBetAction>(_changeBet),
  TypedReducer<Map<String, MatchScore>, ResetBetAction>(_resetBet),
  TypedReducer<Map<String, MatchScore>, ResetBetsAction>(_resetAllBets),
  TypedReducer<Map<String, MatchScore>, SaveBetsAction>(_resetAllBetsOnSave),
]);

Map<String, MatchScore> _changeBet(
    Map<String, MatchScore> bets, ChangeBetAction action) {
  return Map.unmodifiable({}
    ..addAll(bets)
    ..update(action.matchId, (_) => action.bet, ifAbsent: () => action.bet));
}

Map<String, MatchScore> _resetBet(
    Map<String, MatchScore> bets, ResetBetAction action) {
  return Map.unmodifiable({}
    ..addAll(bets)
    ..removeWhere((key, _) => key == action.matchId));
}

Map<String, MatchScore> _resetAllBets(
    Map<String, MatchScore> bets, ResetBetsAction action) {
  return Map.unmodifiable({});
}

Map<String, MatchScore> _resetAllBetsOnSave(
    Map<String, MatchScore> bets, SaveBetsAction action) {
  return Map.unmodifiable({});
}