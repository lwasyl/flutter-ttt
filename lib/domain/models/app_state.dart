import 'package:meta/meta.dart';
import 'package:tic_tac_toe/domain/models/board.dart';
import 'package:tic_tac_toe/domain/models/player.dart';

@immutable
class AppState {

  final Board board;
  final Player winner;
  final Player currentPlayer;

  AppState({
    this.board,
    this.winner,
    this.currentPlayer});

  AppState.initial()
      : board = new Board.empty(),
        winner = null,
        currentPlayer = Player.O;

  AppState copyWith({
    Board board,
    Player winner,
    Player currentPlayer}) =>
      new AppState(
          board: board ?? this.board,
          winner: winner ?? this.winner,
          currentPlayer: currentPlayer ?? this.currentPlayer
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              runtimeType == other.runtimeType &&
              board == other.board &&
              winner == other.winner &&
              currentPlayer == other.currentPlayer;

  @override
  int get hashCode =>
      board.hashCode ^
      winner.hashCode ^
      currentPlayer.hashCode;

  @override
  String toString() {
    return 'AppState{board: ${board.toString()}, winner: $winner, currentPlayer: $currentPlayer}';
  }
}
