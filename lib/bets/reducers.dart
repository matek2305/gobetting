import 'package:redux/redux.dart';

import '../matches/model.dart';
import 'actions.dart';
import 'model.dart';

final unsavedBetsReducer = combineReducers<UnsavedBetsState>([
  TypedReducer<UnsavedBetsState, SaveBetsRequest>(_onSaveBets),
  TypedReducer<UnsavedBetsState, SaveBetsSuccess>(_onSaveBetsSuccess),
  TypedReducer<UnsavedBetsState, SaveBetsFailure>(_onSaveBetsFailure),
  TypedReducer<UnsavedBetsState, ChangeBetAction>(_onChangeBet),
  TypedReducer<UnsavedBetsState, ResetBetAction>(_onResetBet),
  TypedReducer<UnsavedBetsState, ResetBetsAction>(_onResetAllBets),
]);

UnsavedBetsState _onSaveBets(UnsavedBetsState state, SaveBetsRequest action) {
  return state.copyWith(error: null, saving: true);
}

UnsavedBetsState _onSaveBetsSuccess(
    UnsavedBetsState state, SaveBetsSuccess action) {
  return state.copyWith(error: null, saving: false, data: Map.unmodifiable({}));
}

UnsavedBetsState _onSaveBetsFailure(
    UnsavedBetsState state, SaveBetsFailure action) {
  return state.copyWith(error: action.error, saving: false);
}

UnsavedBetsState _onChangeBet(UnsavedBetsState state, ChangeBetAction action) {
  final bets = Map<String, MatchScore>.unmodifiable({}
    ..addAll(state.data)
    ..update(action.matchId, (_) => action.bet, ifAbsent: () => action.bet));
  return state.copyWith(data: bets);
}

UnsavedBetsState _onResetBet(UnsavedBetsState state, ResetBetAction action) {
  final bets = Map<String, MatchScore>.unmodifiable({}
    ..addAll(state.data)
    ..removeWhere((key, _) => key == action.matchId));
  return state.copyWith(data: bets);
}

UnsavedBetsState _onResetAllBets(
    UnsavedBetsState state, ResetBetsAction action) {
  return state.copyWith(data: {});
}
