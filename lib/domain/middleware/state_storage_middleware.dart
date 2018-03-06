import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/domain/actions/actions.dart';
import 'package:tic_tac_toe/domain/models/app_state.dart';
import 'package:tic_tac_toe/domain/models/board.dart';
import 'package:tic_tac_toe/domain/models/player.dart';

List<Middleware<AppState>> createMiddleware() {
  final loadState = _createLoadState();
  final storeState = _createStoreState();

  return combineTypedMiddleware([
    new MiddlewareBinding<AppState, LoadState>(loadState),
    new MiddlewareBinding<AppState, StartGame>(storeState),
    new MiddlewareBinding<AppState, PlaceSymbol>(storeState),
  ]);
}

Middleware<AppState> _createLoadState() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    print("Loading state");
    SharedPreferences.getInstance().then((prefs) {
      var stateJson = prefs.getString("state");
      var stateMap = new JsonDecoder().convert(stateJson);

      print("StateJson: $stateJson");
      print("StateMap: $stateMap");

      var state = new AppState(
        board: new Board.fromList([
          stateMap["board0"].map((str) => getPlayerFromString(str)).toList(),
          stateMap["board1"].map((str) => getPlayerFromString(str)).toList(),
          stateMap["board2"].map((str) => getPlayerFromString(str)).toList(),
        ]),
        winner: getPlayerFromString(stateMap["winner"]),
        currentPlayer: getPlayerFromString(stateMap["current"]),
      );

      print("Loaded state: $state");

      store.dispatch(new StateLoaded(state));
    });
  };
}

Middleware<AppState> _createStoreState() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    print("Saving state");

    SharedPreferences.getInstance().then((prefs) {
      var stateJson = new JsonEncoder().convert({
        "winner": store.state.winner?.toString() ?? "",
        "current": store.state.currentPlayer?.toString() ?? "",
        "board0": store.state.board.getRow(0).map((player) =>
            player.toString()).toList(),
        "board1": store.state.board.getRow(1).map((player) =>
            player.toString()).toList(),
        "board2": store.state.board.getRow(2).map((player) =>
            player.toString()).toList(),
      });
      prefs.setString("state", stateJson);

      print("State: $stateJson");
    });
  };
}

Player getPlayerFromString(String playerAsString) {
  for (Player element in Player.values) {
    if (element.toString() == playerAsString) {
      return element;
    }
  }
  return null;
}
