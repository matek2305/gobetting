import '../model/match.dart';
import '../model/state.dart';
import 'actions.dart';

GoBettingState goBettingStateReducer(GoBettingState state, action) {
  return GoBettingState(
      incomingMatches: incomingMatchesReducer(state.incomingMatches, action),
      unsavedBets: unsavedBetsReducer(state.unsavedBets, action));
}

List<IncomingMatch> incomingMatchesReducer(
    List<IncomingMatch> matches, action) {
  if (action is SaveBetsAction) {
    return matches
        .map((match) => action.bets.containsKey(match.matchId)
            ? match.copyWith(bet: action.bets[match.matchId]!)
            : match)
        .toList();
  }
  return matches;
}

Map<String, MatchScore> unsavedBetsReducer(
    Map<String, MatchScore> bets, action) {
  if (action is ChangeBetAction) {
    return Map.unmodifiable({}
      ..addAll(bets)
      ..update(action.matchId, (_) => action.bet, ifAbsent: () => action.bet));
  }

  if (action is SaveBetsAction) {
    return Map.unmodifiable({});
  }

  if (action is ResetBetsAction) {
    return Map.unmodifiable({});
  }

  return bets;
}
