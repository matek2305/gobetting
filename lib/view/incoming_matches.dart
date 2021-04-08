import '../model/match.dart';

class IncomingMatchesView {
  final List<IncomingMatch> matches;
  final Map<String, MatchScore> unsavedBets;

  Map<String, IncomingMatch> get _matchesById {
    return Map.fromIterable(matches, key: (match) => match.matchId);
  }

  IncomingMatchesView(this.matches, this.unsavedBets);

  MatchScore? betFor(String matchId) {
    return unsavedBets[matchId] ?? _matchesById[matchId]?.bet;
  }
}