class AuthState {
  final dynamic error;
  final bool loading;
  final bool loggedIn;
  final String? token;
  final String? refreshToken;

  AuthState({
    required this.error,
    required this.loading,
    required this.loggedIn,
    this.token,
    this.refreshToken,
  });

  factory AuthState.initial() => AuthState(
        error: null,
        loading: false,
        loggedIn: false,
      );

  AuthState copyWith({
    dynamic error,
    bool? loading,
    bool? loggedIn,
    String? token,
    String? refreshToken,
  }) {
    return AuthState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      loggedIn: loggedIn ?? this.loading,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
