import 'package:minesweeper/models/game_state.dart';

class PlayerState {
  int cellsRemaining = 0;
  GameState state = GameState.RUNNING;

  PlayerState();
}