import 'auth.dart';
import 'match.dart';

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
