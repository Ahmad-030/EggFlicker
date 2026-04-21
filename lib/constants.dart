// lib/utils/constants.dart

import 'package:flutter/material.dart';

class AppColors {
  static const background     = Color(0xFF1A0A2E);
  static const primary        = Color(0xFFFF6B35);
  static const secondary      = Color(0xFFFFD700);
  static const accent         = Color(0xFF00E5FF);
  static const cardBg         = Color(0xFF2D1B4E);
  static const textPrimary    = Color(0xFFFFF8F0);
  static const textSecondary  = Color(0xFFB8A9C9);
  static const livesRed       = Color(0xFFFF3B5C);
  static const comboGold      = Color(0xFFFFD700);
  static const shadow         = Color(0x99000000);

  // Egg colours
  static const eggNormal  = Color(0xFFFFF8F0);
  static const eggGolden  = Color(0xFFFFD700);
  static const eggRotten  = Color(0xFF4CAF50);
  static const eggBomb    = Color(0xFF212121);
  static const eggFrozen  = Color(0xFF80DEEA);
}

class AppSizes {
  static const basketWidth  = 110.0;
  static const basketHeight = 55.0;
  static const eggWidth     = 42.0;
  static const eggHeight    = 52.0;
  static const henWidth     = 70.0;
  static const henHeight    = 70.0;
}

class AppStrings {
  static const appName        = 'EggFlicker';
  static const tagline        = 'Catch the right ones!';
  static const developerName  = 'Silikasdong';
  static const developerEmail = 'sailikuerdong@gmail.com';

}

class GameConfig {
  static const initialLives         = 3;
  static const initialFallSpeed     = 180.0; // px/s
  static const maxFallSpeed         = 520.0;
  static const speedIncrement       = 18.0;  // added every interval
  static const speedInterval        = 12;    // seconds
  static const spawnInterval        = 1400;  // ms base
  static const minSpawnInterval     = 550;   // ms floor
  static const timeAttackDuration   = 60;    // seconds
  static const comboThreshold       = 5;     // catches for 2x
  static const comboMultiplier      = 2.0;

  // Points
  static const pointsNormal = 1;
  static const pointsGolden = 5;
  static const pointsRotten = -3;

  // Egg spawn weights (out of 100)
  static const weightNormal = 50;
  static const weightGolden = 15;
  static const weightRotten = 20;
  static const weightBomb   = 8;
  static const weightFrozen = 7;
}

enum EggType { normal, golden, rotten, bomb, frozen }

enum GameMode { classic, timeAttack }

enum GameState { playing, paused, gameOver }