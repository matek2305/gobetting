import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../model/state.dart';

class LoginRequest {
  
}

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
    var loginUri = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBq7RMPch2FpvtSWsuiUnUXSci2GiKn9Wg");
    var response = await http.post(loginUri, body: {
      "email": "$username@go-betting.herokuapp.com",
      "password": password,
      "returnSecureToken": "true",
    });

    if (response.statusCode != 200) {
      store.dispatch(LoginFailure(response.body));
      return;
    }

    var json = jsonDecode(response.body);
    store.dispatch(LoginSuccess(json["idToken"], json["refreshToken"]));
  };
}
