
import 'package:redux/redux.dart';

import '../model/auth.dart';
import 'auth_actions.dart';

final authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, LoginRequest>(_onLoginRequest),
  TypedReducer<AuthState, LoginSuccess>(_onLoginSuccess),
  TypedReducer<AuthState, LoginFailure>(_onLoginFailure),
]);

AuthState _onLoginRequest(AuthState state, LoginRequest _) {
  return state.copyWith(loading: true, loggedIn: false, error: null);
}

AuthState _onLoginSuccess(AuthState state, LoginSuccess action) {
  return state.copyWith(
    loading: false,
    loggedIn: true,
    error: null,
    token: action.token,
    refreshToken: action.refreshToken,
  );
}

AuthState _onLoginFailure(AuthState state, LoginFailure action) {
  return state.copyWith(
    loading: false,
    loggedIn: false,
    error: action.error,
  );
}
