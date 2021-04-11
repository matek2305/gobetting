import 'auth.dart';
import 'match.dart';

class GoBettingState {
  final AuthState? auth;
  final List<IncomingMatch> incomingMatches;
  final Map<String, MatchScore> unsavedBets;

  GoBettingState({
    this.auth,
    required this.incomingMatches,
    required this.unsavedBets,
  });

  GoBettingState.initial()
      : auth = null,
        incomingMatches = List.unmodifiable(<IncomingMatch>[
          IncomingMatch(
            '1',
            'Chelsea',
            'Arsenal',
            DateTime.now().add(Duration(hours: 3)),
          ),
          IncomingMatch(
            '2',
            'Manchester United',
            'Manchester City',
            DateTime.now().add(Duration(hours: 12)),
          ),
          IncomingMatch(
            '3',
            'Polska',
            'Andora',
            DateTime.now().add(Duration(hours: 2)),
            MatchScore(4, 0),
          ),
        ]),
        unsavedBets = Map.unmodifiable(<String, MatchScore>{});
}
