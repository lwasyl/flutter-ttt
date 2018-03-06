import 'package:tic_tac_toe/domain/models/app_state.dart';

class PlaceSymbol {
  final int x;
  final int y;

  PlaceSymbol(this.x, this.y); // Current player is inferred from the state
}

class StartGame {}

class LoadState {}

class StateLoaded {
  final AppState state;

  StateLoaded(this.state);
}
