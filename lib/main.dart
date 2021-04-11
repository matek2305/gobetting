import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'model/state.dart';
import 'redux/reducers.dart';
import 'screens/auth_screen.dart';

void main() => runApp(GoBettingApp());

class GoBettingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Store<GoBettingState> store = Store<GoBettingState>(
      goBettingStateReducer,
      initialState: GoBettingState.initial(),
    );

    return StoreProvider<GoBettingState>(
      store: store,
      child: CupertinoApp(
        home: AuthScreen(),
      ),
    );
  }
}
