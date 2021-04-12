import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'navigation/middleware.dart';
import 'redux.dart';
import 'screens/auth_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() => runApp(GoBettingApp());

class GoBettingApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Store<GoBettingState> store = Store<GoBettingState>(
      goBettingStateReducer,
      initialState: GoBettingState.initial(),
      middleware: [
        thunkMiddleware,
        ...NavigationMiddleware(navigatorKey).getMiddlewares(),
        new LoggingMiddleware.printer(),
      ],
    );

    return StoreProvider<GoBettingState>(
      store: store,
      child: CupertinoApp(
        navigatorKey: navigatorKey,
        home: AuthScreen(),
      ),
    );
  }
}
