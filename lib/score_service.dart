// lib/services/score_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  ScoreService._();
  static final ScoreService instance = ScoreService._();

  static const _classicKey    = 'highscore_classic';
  static const _timeAttackKey = 'highscore_timeattack';

  Future<int> getClassicHighScore() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_classicKey) ?? 0;
  }

  Future<int> getTimeAttackHighScore() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_timeAttackKey) ?? 0;
  }

  Future<bool> saveClassicScore(int score) async {
    final current = await getClassicHighScore();
    if (score > current) {
      final p = await SharedPreferences.getInstance();
      await p.setInt(_classicKey, score);
      return true; // new record
    }
    return false;
  }

  Future<bool> saveTimeAttackScore(int score) async {
    final current = await getTimeAttackHighScore();
    if (score > current) {
      final p = await SharedPreferences.getInstance();
      await p.setInt(_timeAttackKey, score);
      return true;
    }
    return false;
  }
}