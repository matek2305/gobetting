import 'package:redux/redux.dart';

import '../model/match.dart';
import '../model/state.dart';
import '../redux/actions.dart';

class IncomingMatchesView {
  final List<IncomingMatch> matches;
  final Map<String, MatchScore> unsavedBets;
  final Function(String, MatchScore) onBetChange;
  final Function(Map<String, MatchScore>) onSaveBets;
  final Function(String) onResetBet;
  final Function() onResetBets;

  Map<String, IncomingMatch> get _matchesById {
    return Map.fromIterable(matches, key: (match) => match.matchId);
  }

  IncomingMatchesView({
    required this.matches,
    required this.unsavedBets,
    required this.onBetChange,
    required this.onSaveBets,
    required this.onResetBet,
    required this.onResetBets,
  });

  MatchScore? betFor(String matchId) {
    return unsavedBets[matchId] ?? _matchesById[matchId]?.bet;
  }

  factory IncomingMatchesView.create(Store<GoBettingState> store) {
    _onBetChange(String matchId, MatchScore bet) {
      store.dispatch(ChangeBetAction(matchId, bet));
    }

    _onSaveBets(Map<String, MatchScore> bets) {
      store.dispatch(SaveBetsAction(bets));
    }

    _onResetBet(String matchId) {
      store.dispatch(ResetBetAction(matchId));
    }

    _onResetBets() {
      store.dispatch(ResetBetsAction());
    }

    return IncomingMatchesView(
      matches: store.state.incomingMatches,
      unsavedBets: store.state.unsavedBets,
      onBetChange: _onBetChange,
      onSaveBets: _onSaveBets,
      onResetBet: _onResetBet,
      onResetBets: _onResetBets,
    );
  }
}
