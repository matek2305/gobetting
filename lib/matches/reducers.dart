import 'package:redux/redux.dart';

import '../bets/actions.dart';
import 'actions.dart';
import 'model.dart';

final incomingMatchesReducer = combineReducers<IncomingMatchesState>([
  TypedReducer<IncomingMatchesState, FetchIncomingMatchesRequest>(
      _onFetchRequest),
  TypedReducer<IncomingMatchesState, FetchIncomingMatchesSuccess>(
      _onFetchSuccess),
  TypedReducer<IncomingMatchesState, FetchIncomingMatchesFailure>(
      _onFetchFailure),
  TypedReducer<IncomingMatchesState, SaveBetsAction>(_saveBets),
  TypedReducer<IncomingMatchesState, ChangeBetAction>(_changeBet),
  TypedReducer<IncomingMatchesState, ResetBetAction>(_resetBet),
  TypedReducer<IncomingMatchesState, ResetBetsAction>(_resetAllBets),
]);

IncomingMatchesState _onFetchRequest(
  IncomingMatchesState state,
  FetchIncomingMatchesRequest action,
) {
  return state.copyWith(loading: true, error: null);
}

IncomingMatchesState _onFetchSuccess(
  IncomingMatchesState state,
  FetchIncomingMatchesSuccess action,
) {
  return state.copyWith(
    loading: false,
    error: null,
    incomingMatches: action.matches,
    unsavedBets: {},
  );
}

IncomingMatchesState _onFetchFailure(
  IncomingMatchesState state,
  FetchIncomingMatchesFailure action,
) {
  return state.copyWith(loading: false, error: action.error);
}

IncomingMatchesState _saveBets(
  IncomingMatchesState state,
  SaveBetsAction action,
) {
  final incomingMatches = state.incomingMatches
      .map((match) => action.bets.containsKey(match.matchId)
          ? match.copyWith(bet: action.bets[match.matchId]!)
          : match)
      .toList();
  return state.copyWith(incomingMatches: incomingMatches, unsavedBets: {});
}

IncomingMatchesState _changeBet(
    IncomingMatchesState state, ChangeBetAction action) {
  final bets = Map<String, MatchScore>.unmodifiable({}
    ..addAll(state.unsavedBets)
    ..update(action.matchId, (_) => action.bet, ifAbsent: () => action.bet));
  return state.copyWith(unsavedBets: bets);
}

IncomingMatchesState _resetBet(
    IncomingMatchesState state, ResetBetAction action) {
  final bets = Map<String, MatchScore>.unmodifiable({}
    ..addAll(state.unsavedBets)
    ..removeWhere((key, _) => key == action.matchId));
  return state.copyWith(unsavedBets: bets);
}

IncomingMatchesState _resetAllBets(
    IncomingMatchesState state, ResetBetsAction action) {
  return state.copyWith(unsavedBets: {});
}
