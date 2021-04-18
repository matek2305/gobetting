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
  TypedReducer<IncomingMatchesState, SaveBetsSuccess>(_onSaveBetsSuccess),
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
    data: action.matches,
  );
}

IncomingMatchesState _onFetchFailure(
  IncomingMatchesState state,
  FetchIncomingMatchesFailure action,
) {
  return state.copyWith(loading: false, error: action.error);
}

IncomingMatchesState _onSaveBetsSuccess(
  IncomingMatchesState state,
  SaveBetsSuccess action,
) {
  final incomingMatches = state.data
      .map((match) => action.bets.containsKey(match.matchId)
          ? match.copyWith(bet: action.bets[match.matchId]!)
          : match)
      .toList();
  return state.copyWith(data: incomingMatches);
}
