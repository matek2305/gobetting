import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../auth/actions.dart';
import '../redux.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('GoBetting'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StoreConnector<GoBettingState, _AuthView>(
            converter: (store) => _AuthView.create(store),
            builder: (_, view) => Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (view.hasError)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        view.error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (view.isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("LOGGING IN ..."),
                    ),
                  CupertinoTextField(
                    placeholder: "Username",
                    controller: _usernameController,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CupertinoTextField(
                    placeholder: "Password",
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoButton.filled(
                      child: Text("LOGIN"),
                      onPressed: view.isLoading
                          ? null
                          : () => view.onLogin(
                                _usernameController.value.text,
                                _passwordController.value.text,
                              ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthView {
  final dynamic error;
  final bool isLoading;
  final Function(String, String) onLogin;

  bool get hasError => error != null;

  _AuthView({
    required this.error,
    required this.isLoading,
    required this.onLogin,
  });

  factory _AuthView.create(Store<GoBettingState> store) {
    _onLogin(String username, String password) {
      store.dispatch(login(username, password));
    }

    return _AuthView(
      error: store.state.auth.error,
      isLoading: store.state.auth.loading,
      onLogin: _onLogin,
    );
  }
}
