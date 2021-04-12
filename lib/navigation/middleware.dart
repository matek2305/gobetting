import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

import '../redux.dart';
import '../screens/auth_screen.dart';
import '../screens/incoming_matches_screen.dart';
import 'actions.dart';
import 'destinations.dart';

class NavigationMiddleware {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationMiddleware(this.navigatorKey);

  List<Middleware<GoBettingState>> getMiddlewares() {
    return [
      TypedMiddleware<GoBettingState, NavigateToNext>(_onNavigateToNext()),
      TypedMiddleware<GoBettingState, NavigateToNextAndReplace>(_onNavigateToNextAndReplace()),
      TypedMiddleware<GoBettingState, NavigateBack>(_onNavigateBack()),
    ];
  }

  Middleware<GoBettingState> _onNavigateToNext() {
    return (Store<GoBettingState> store, action, NextDispatcher next) {
      final currentDestination = (action as NavigateToNext).destination;
      navigatorKey.currentState!.push(CupertinoPageRoute(
          builder: (BuildContext context) => _convert(currentDestination)
      ));
      next(action);
    };
  }

  Middleware<GoBettingState> _onNavigateToNextAndReplace() {
    return (Store<GoBettingState> store, action, NextDispatcher next) {
      final currentDestination = (action as NavigateToNextAndReplace).destination;
      navigatorKey.currentState!.pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) => _convert(currentDestination)
      ));
      next(action);
    };
  }

  Middleware<GoBettingState> _onNavigateBack() {
    return (Store<GoBettingState> store, action, NextDispatcher next) {
      final currentActivePages = store.state.activePages;
      if (currentActivePages.length == 1) SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      navigatorKey.currentState!.pop();
      next(action);
    };
  }

  Widget _convert(Destination input) {
    switch (input) {
      case Destination.HOME:
        return IncomingMatchesScreen();
      case Destination.LOGIN:
        return AuthScreen();
      default: return AuthScreen();
    }
  }
}
