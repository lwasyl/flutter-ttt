import 'package:tic_tac_toe/domain/actions/actions.dart';
import 'package:tic_tac_toe/domain/models/app_state.dart';
import 'package:tic_tac_toe/domain/models/board.dart';
import 'package:tic_tac_toe/domain/models/player.dart';

dynamic appReducer(state, action) {
  switch (action.runtimeType) {
    case PlaceSymbol:
      return handlePlaceSymbol(state, action);
    case StartGame:
      return handleStartGame(state);
    case StateLoaded:
      return action.state;
    default:
      return state;
  }
}

AppState handleStartGame(AppState state) =>
    new AppState(
        board: new Board.empty(),
        winner: null,
        currentPlayer: Player.X
    );

AppState handlePlaceSymbol(AppState state, PlaceSymbol action) {
  var newBoard = state.board.makeMove(action.x, action.y, state.currentPlayer);

  if (newBoard == null) {
    return state;
  } else {
    Player nextPlayer;
    if (state.currentPlayer == Player.X) {
      nextPlayer = Player.O;
    } else {
      nextPlayer = Player.X;
    }
    return new AppState(
        board: newBoard,
        winner: _getWinner(
            newBoard, action.x, action.y, state.currentPlayer
        ),
        currentPlayer: nextPlayer
    );
  }
}

Player _getWinner(Board board, int moveX, int moveY, Player player) {
  for (int y = 0; y < 3; y++) {
    if (board.getField(moveX, y) != player) break;
    if (y == 2) return player;
  }

  for (int x = 0; x < 3; x++) {
    if (board.getField(x, moveY) != player) break;
    if (x == 2) return player;
  }

  if (moveX == moveY) { // We're on the diagonal
    for (int i = 0; i < 3; i++) {
      if (board.getField(i, i) != player) break;
      if (i == 2) return player;
    }
  }

  if (moveX + moveY == 2) { // We're on the anti diagonal
    for (int i = 0; i < 3; i++) {
      if (board.getField(i, 2 - i) != player) break;
      if (i == 2) return player;
    }
  }

  for (int x = 0; x < 3; x++) {
    for (int y = 0; y < 3; y++) {
      if (board.getField(x, y) == Player.NONE) return null;
      if (x == 2 && y == 2) return Player.NONE; // Draw
    }
  }

  return null;
}
