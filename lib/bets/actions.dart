import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../matches/model.dart';
import '../redux.dart';

class ChangeBetAction {
  final String matchId;
  final MatchScore bet;

  ChangeBetAction(this.matchId, this.bet);
}

class ResetBetsAction {}

class ResetBetAction {
  final String matchId;

  ResetBetAction(this.matchId);
}

class SaveBetsRequest {}

class SaveBetsSuccess {
  final Map<String, MatchScore> bets;

  SaveBetsSuccess(this.bets);
}

class SaveBetsFailure {
  final dynamic error;

  SaveBetsFailure(this.error);
}

ThunkAction<GoBettingState> saveBets() {
  return (Store<GoBettingState> store) async {
    store.dispatch(SaveBetsRequest());
    var playerBetsUri =
        Uri.parse("https://go-betting.herokuapp.com/player_bets");
    var response = await http.post(
      playerBetsUri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${store.state.auth.token}",
      },
      body: jsonEncode({
        "bets": store.state.unsavedBets.data.entries
            .map((entry) => {
                  "matchId": entry.key,
                  "homeTeamScore": entry.value.homeTeam,
                  "awayTeamScore": entry.value.awayTeam,
                })
            .toList(),
      }),
    );

    if (response.statusCode != 200) {
      store.dispatch(SaveBetsFailure(response.body));
      return;
    }

    store.dispatch(SaveBetsSuccess(store.state.unsavedBets.data));
  };
}
