import 'auth/model.dart';
import 'auth/reducers.dart';
import 'bets/model.dart';
import 'bets/reducers.dart';

class GoBettingState {
  final AuthState auth;
  final List<IncomingMatch> incomingMatches;
  final Map<String, MatchScore> unsavedBets;

  GoBettingState({
    required this.auth,
    required this.incomingMatches,
    required this.unsavedBets,
  });

  factory GoBettingState.initial() => GoBettingState(
        auth: AuthState.initial(),
        incomingMatches: List.unmodifiable([]),
        unsavedBets: Map.unmodifiable({}),
      );
}

GoBettingState goBettingStateReducer(GoBettingState state, action) {
  return GoBettingState(
      auth: authReducer(state.auth, action),
      incomingMatches: incomingMatchesReducer(state.incomingMatches, action),
      unsavedBets: unsavedBetsReducer(state.unsavedBets, action));
}
