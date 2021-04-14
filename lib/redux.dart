import 'dart:collection';

import 'auth/model.dart';
import 'auth/reducers.dart';
import 'matches/model.dart';
import 'matches/reducers.dart';
import 'navigation/destinations.dart';
import 'navigation/reducers.dart';

class GoBettingState {
  final AuthState auth;
  final IncomingMatchesState incomingMatches;
  final Queue<Destination> activePages;

  GoBettingState({
    required this.auth,
    required this.incomingMatches,
    required this.activePages,
  });

  factory GoBettingState.initial() => GoBettingState(
        auth: AuthState.initial(),
        incomingMatches: IncomingMatchesState.initial(),
        activePages: new Queue()..add(Destination.LOGIN),
      );
}

GoBettingState goBettingStateReducer(GoBettingState state, action) {
  return GoBettingState(
    auth: authReducer(state.auth, action),
    incomingMatches: incomingMatchesReducer(state.incomingMatches, action),
    activePages: navigationReducer(state.activePages, action)
  );
}
