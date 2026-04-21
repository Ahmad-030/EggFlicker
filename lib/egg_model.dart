// lib/models/egg_model.dart

import 'constants.dart';

class EggModel {
  final String id;
  final EggType type;
  double x;        // left offset (0..screenWidth)
  double y;        // top offset
  double speed;    // px per second
  bool caught;
  bool missed;

  EggModel({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.speed,
    this.caught = false,
    this.missed = false,
  });

  /// Points awarded (negative for rotten, 0 for bomb/frozen)
  int get points {
    switch (type) {
      case EggType.normal: return GameConfig.pointsNormal;
      case EggType.golden: return GameConfig.pointsGolden;
      case EggType.rotten: return GameConfig.pointsRotten;
      case EggType.bomb:   return 0;
      case EggType.frozen: return 0;
    }
  }

  bool get isGood  => type == EggType.normal || type == EggType.golden;
  bool get isBad   => type == EggType.rotten;
  bool get isBomb  => type == EggType.bomb;
  bool get isFrozen=> type == EggType.frozen;
}