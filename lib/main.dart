import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:tic_tac_toe/domain/actions/actions.dart';
import 'package:tic_tac_toe/domain/middleware/state_storage_middleware.dart';
import 'package:tic_tac_toe/domain/models/app_state.dart';
import 'package:tic_tac_toe/domain/models/player.dart';
import 'package:tic_tac_toe/domain/reducers/app_state_reducer.dart';

void main() => runApp(new TicTacToe());

class TicTacToe extends StatelessWidget {

  final store = new DevToolsStore(
      appReducer,
      initialState: new AppState.initial(),
      middleware: createMiddleware()
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: this.store,
      child: new MaterialApp(
        title: "Tic Tac Toe",
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text("Tic Tac Toe"),
          ),
          body: new GameScreen((x, y) {}),
          drawer: new Container(
              width: 180.0,
              color: Colors.white,
              child: new ReduxDevTools(this.store)),
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {

  final MakeMove makeMove;

  GameScreen(this.makeMove);

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder(
      onInit: (store) => store.dispatch(new LoadState()),
      builder: (context, Store<AppState> store) =>
      new Column(
          children: [
            new Table(
                children: <TableRow>[
                  new TableRow(children: [
                    new GameButton(0, 0),
                    new GameButton(0, 1),
                    new GameButton(0, 2),
                  ],),
                  new TableRow(children: [
                    new GameButton(1, 0),
                    new GameButton(1, 1),
                    new GameButton(1, 2),
                  ],),
                  new TableRow(children: [
                    new GameButton(2, 0),
                    new GameButton(2, 1),
                    new GameButton(2, 2),
                  ],),
                ],
                border: new TableBorder.all(width: 1.0)
            ),
            new Offstage(
                offstage: store.state.winner == null,
                child: new Text("Winner: ${store.state.winner}")),
            new RaisedButton(onPressed: () {
              store.dispatch(new StartGame());
            },
              color: Theme
                  .of(context)
                  .accentColor,
              child: new Text("Restart"),),
          ]
      ),
    );
  }
}

class GameButton extends StatelessWidget {

  final int x;
  final int y;

  GameButton(this.x, this.y) : super(key: new ValueKey("$x$y"));

  @override
  Widget build(BuildContext context) =>
      new StoreBuilder(
        builder: (context, Store<AppState> store) =>
        new Container(
          child: new AspectRatio(
            aspectRatio: 1.0,
            child: new FlatButton(
              onPressed: store.state.winner != null ? null : () {
                new StoreProvider.of(context).store.dispatch(
                    new PlaceSymbol(x, y));
              },
              child: new Text(
                getText(store.state.board.getField(x, y)),
                textScaleFactor: 4.0,
              ),
            ),
          ),
        ),
      );

  String getText(Player player) {
    switch (player) {
      case Player.X:
        return "X";
      case Player.O:
        return "O";
      default:
        return "";
    }
  }
}

typedef void MakeMove(int x, int y);
