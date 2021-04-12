import 'dart:collection';

import 'package:redux/redux.dart';

import 'actions.dart';
import 'destinations.dart';

final navigationReducer = combineReducers<Queue<Destination>>([
  TypedReducer<Queue<Destination>, NavigateToNext>(_onNavigateToNext),
  TypedReducer<Queue<Destination>, NavigateToNextAndReplace>(_onNavigateToNextAndReplace),
  TypedReducer<Queue<Destination>, NavigateBack>(_onNavigateBack),
]);

Queue<Destination> _onNavigateToNext(Queue<Destination> state, NavigateToNext action) {
  return state..add(action.destination);
}

Queue<Destination> _onNavigateToNextAndReplace(Queue<Destination> state, NavigateToNextAndReplace action) {
  return state..removeLast()..add(action.destination);
}

Queue<Destination> _onNavigateBack(Queue<Destination> state, NavigateBack _) {
  return state..removeLast();
}