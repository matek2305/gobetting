import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../navigation/actions.dart';
import '../navigation/destinations.dart';
import '../redux.dart';

class LoginRequest {}

class LoginSuccess {
  final String token;
  final String refreshToken;

  LoginSuccess(this.token, this.refreshToken);
}

class LoginFailure {
  final dynamic error;

  LoginFailure(this.error);
}

ThunkAction<GoBettingState> login(String username, String password) {
  return (Store<GoBettingState> store) async {
    store.dispatch(LoginRequest());
    var loginUri = Uri.parse("https://go-betting.herokuapp.com/login");
    var response = await http.post(
      loginUri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode != 200) {
      store.dispatch(
          LoginFailure(jsonDecode(response.body)["error"]["message"]));
      return;
    }

    var json = jsonDecode(response.body);
    store.dispatch(LoginSuccess(json["idToken"], json["refreshToken"]));
    store.dispatch(NavigateToNextAndReplace(destination: Destination.HOME));
  };
}
