import 'package:gobetting/redux/auth_reducer.dart';
import 'package:redux/redux.dart';

import '../model/match.dart';
import '../model/state.dart';
import 'actions.dart';

GoBettingState goBettingStateReducer(GoBettingState state, action) {
  return GoBettingState(
      auth: authReducer(state.auth, action),
      incomingMatches: _incomingMatchesReducer(state.incomingMatches, action),
      unsavedBets: _unsavedBetsReducer(state.unsavedBets, action));
}

final _incomingMatchesReducer = combineReducers<List<IncomingMatch>>([
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

final _unsavedBetsReducer = combineReducers<Map<String, MatchScore>>([
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
