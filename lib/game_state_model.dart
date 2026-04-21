// lib/models/game_state_model.dart

import 'constants.dart';
import 'egg_model.dart';

class GameStateModel {
  int score;
  int lives;
  int combo;
  double multiplier;
  int secondsElapsed;
  bool isFrozen;          // basket slowed by ice egg
  double frozenSecondsLeft;
  List<EggModel> eggs;
  GameState state;
  GameMode mode;

  GameStateModel({
    required this.mode,
    this.score           = 0,
    this.lives           = GameConfig.initialLives,
    this.combo           = 0,
    this.multiplier      = 1.0,
    this.secondsElapsed  = 0,
    this.isFrozen        = false,
    this.frozenSecondsLeft = 0,
    List<EggModel>? eggs,
    this.state           = GameState.playing,
  }) : eggs = eggs ?? [];

  int get timeLeft => GameConfig.timeAttackDuration - secondsElapsed;
  bool get isTimeAttackOver =>
      mode == GameMode.timeAttack && secondsElapsed >= GameConfig.timeAttackDuration;
}