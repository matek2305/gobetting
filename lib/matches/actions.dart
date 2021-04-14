import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../redux.dart';
import 'model.dart';

class FetchIncomingMatchesRequest {

}

class FetchIncomingMatchesSuccess {
  final List<IncomingMatch> matches;

  FetchIncomingMatchesSuccess(this.matches);
}

class FetchIncomingMatchesFailure {
  final dynamic error;

  FetchIncomingMatchesFailure(this.error);
}

ThunkAction<GoBettingState> fetchIncomingMatches() {
  return (Store<GoBettingState> store) async {
    store.dispatch(FetchIncomingMatchesRequest());
    var nextMatchesResource = Uri.parse(
        "https://go-betting.herokuapp.com/betting_rooms/global/next_matches");

    var response = await http.get(nextMatchesResource, headers: {
      "Authorization": "Bearer ${store.state.auth.token}",
    });

    if (response.statusCode == 200) {
      final Iterable json = jsonDecode(response.body);
      final matches = json.map((entry) => IncomingMatch.fromJson(entry)).toList();
      store.dispatch(FetchIncomingMatchesSuccess(matches));
      return;
    }

    store.dispatch(FetchIncomingMatchesFailure(response.body));
  };
}