import 'package:meta/meta.dart';
import 'package:tic_tac_toe/domain/models/player.dart';

@immutable
class Board {

  final List<List<Player>> _board;

  Board.empty() :
        _board = new List.generate(
            3, (idx) => new List.generate(3, (idx) => Player.NONE));

  Board.fromList(List<List<Player>> board) : _board = board;

  Board._fromBoard(this._board);

  Board makeMove(int posX, int posY, Player symbol) {
    var currentValue = _board[posX][posY];

    if (currentValue == Player.NONE) {
      return new Board._fromBoard(new List.generate(3, (x) =>
      new List.generate(3, (y) {
        if (x == posX && y == posY) {
          return symbol;
        } else {
          return _board[x][y];
        }
      })));
    } else {
      return null;
    }
  }

  Player getField(int x, int y) => _board[x][y];

  List<Player> getRow(x) => _board[x];

  @override
  String toString() => _board.map((it) => it.join(",")).join("\n");
}
