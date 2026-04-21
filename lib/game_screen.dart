// lib/screens/game_screen.dart

import 'dart:async';
import 'dart:math';
import 'package:eggflicker/pause_overlay.dart';
import 'package:eggflicker/score_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'audio_service.dart';
import 'basket_widget.dart';
import 'constants.dart';
import 'egg_model.dart';
import 'egg_widget.dart';
import 'game_state_model.dart';
import 'gameover_screen.dart';
import 'hud_widget.dart';

class GameScreen extends StatefulWidget {
  final GameMode mode;
  const GameScreen({super.key, required this.mode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────────────
  late GameStateModel _gs;
  double _basketX = 0;          // center x of basket
  double _fallSpeed = GameConfig.initialFallSpeed;
  int _spawnIntervalMs = GameConfig.spawnInterval;

  // ── Timers ───────────────────────────────────────────────────────────────
  Timer? _gameLoop;
  Timer? _spawnTimer;
  Timer? _secondTimer;
  Timer? _diffTimer;

  // ── Score popup tracking ─────────────────────────────────────────────────
  final List<_ScorePopup> _popups = [];

  // ── Misc ─────────────────────────────────────────────────────────────────
  final _rand = Random();
  double _screenWidth = 400;
  double _screenHeight = 800;
  static const _fps = 60;
  static const _dt = 1.0 / _fps;
  int _eggCounter = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _gs = GameStateModel(mode: widget.mode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final size = MediaQuery.of(context).size;
      _screenWidth = size.width;
      _screenHeight = size.height;
      _basketX = _screenWidth / 2;
      _startGame();
    }
  }

  // ── Game lifecycle ────────────────────────────────────────────────────────

  void _startGame() {
    _startGameLoop();
    _startSpawnTimer();
    _startSecondTimer();
    _startDifficultyTimer();
  }

  void _startGameLoop() {
    _gameLoop = Timer.periodic(
      Duration(milliseconds: (1000 / _fps).round()),
          (_) => _tick(),
    );
  }

  void _startSpawnTimer() {
    _spawnTimer?.cancel();
    _spawnTimer = Timer.periodic(
      Duration(milliseconds: _spawnIntervalMs),
          (_) {
        if (_gs.state == GameState.playing) _spawnEgg();
      },
    );
  }

  void _startSecondTimer() {
    _secondTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_gs.state != GameState.playing) return;
      setState(() => _gs.secondsElapsed++);
      if (_gs.isTimeAttackOver) _triggerGameOver();
    });
  }

  void _startDifficultyTimer() {
    _diffTimer = Timer.periodic(
      Duration(seconds: GameConfig.speedInterval),
          (_) {
        if (_gs.state != GameState.playing) return;
        _fallSpeed = min(_fallSpeed + GameConfig.speedIncrement, GameConfig.maxFallSpeed);
        _spawnIntervalMs = max(_spawnIntervalMs - 80, GameConfig.minSpawnInterval);
        _startSpawnTimer();
      },
    );
  }

  void _stopTimers() {
    _gameLoop?.cancel();
    _spawnTimer?.cancel();
    _secondTimer?.cancel();
    _diffTimer?.cancel();
  }

  void _tick() {
    if (_gs.state != GameState.playing) return;

    // Frozen countdown
    if (_gs.isFrozen) {
      _gs.frozenSecondsLeft -= _dt;
      if (_gs.frozenSecondsLeft <= 0) _gs.isFrozen = false;
    }

    final basketSpeed = _gs.isFrozen ? 1.0 : 1.0; // movement is drag-based

    // Move eggs down
    bool changed = false;
    final toRemove = <EggModel>[];

    for (final egg in _gs.eggs) {
      if (egg.caught || egg.missed) continue;
      egg.y += egg.speed * _dt;

      // Check catch collision
      final basketTop = _screenHeight - AppSizes.basketHeight - 16;
      final basketLeft = _basketX - AppSizes.basketWidth / 2;
      final basketRight = _basketX + AppSizes.basketWidth / 2;

      final eggCenterX = egg.x + AppSizes.eggWidth / 2;
      final eggBottom = egg.y + AppSizes.eggHeight;

      if (eggBottom >= basketTop &&
          eggBottom <= basketTop + AppSizes.basketHeight + 20 &&
          eggCenterX >= basketLeft &&
          eggCenterX <= basketRight) {
        _handleCatch(egg);
        toRemove.add(egg);
        changed = true;
        continue;
      }

      // Missed – fell off screen
      if (egg.y > _screenHeight) {
        _handleMiss(egg);
        toRemove.add(egg);
        changed = true;
      }
    }

    _gs.eggs.removeWhere((e) => toRemove.contains(e));

    // Clean old popups
    _popups.removeWhere((p) => DateTime.now().difference(p.time).inMilliseconds > 900);

    if (changed || _gs.eggs.isNotEmpty) setState(() {});
  }

  // ── Egg spawning ──────────────────────────────────────────────────────────

  void _spawnEgg() {
    final type = _randomEggType();
    final x = _rand.nextDouble() * (_screenWidth - AppSizes.eggWidth);
    final speedVariance = _rand.nextDouble() * 40 - 20;
    final egg = EggModel(
      id: 'egg_${_eggCounter++}',
      type: type,
      x: x,
      y: -AppSizes.eggHeight,
      speed: _fallSpeed + speedVariance,
    );
    setState(() => _gs.eggs.add(egg));
  }

  EggType _randomEggType() {
    final r = _rand.nextInt(100);
    if (r < GameConfig.weightNormal) return EggType.normal;
    if (r < GameConfig.weightNormal + GameConfig.weightGolden) return EggType.golden;
    if (r < GameConfig.weightNormal + GameConfig.weightGolden + GameConfig.weightRotten)
      return EggType.rotten;
    if (r < GameConfig.weightNormal + GameConfig.weightGolden + GameConfig.weightRotten + GameConfig.weightBomb)
      return EggType.bomb;
    return EggType.frozen;
  }

  // ── Catch / miss logic ────────────────────────────────────────────────────

  void _handleCatch(EggModel egg) {
    if (egg.isBomb) {
      _addPopup('💥 BOOM!', Colors.red, egg.x, egg.y);
      _loseLife();
      _loseLife();
      return;
    }

    if (egg.isFrozen) {
      _addPopup('❄️ Frozen!', AppColors.eggFrozen, egg.x, egg.y);
      _gs.isFrozen = true;
      _gs.frozenSecondsLeft = 3;
      return;
    }

    if (egg.isBad) {
      _gs.combo = 0;
      _gs.multiplier = 1.0;
      final pts = (egg.points * _gs.multiplier).toInt();
      _gs.score = max(0, _gs.score + pts);
      _addPopup('${egg.points}', AppColors.livesRed, egg.x, egg.y);
      _loseLife();
      return;
    }

    // Good egg
    _gs.combo++;
    if (_gs.combo >= GameConfig.comboThreshold) {
      _gs.multiplier = GameConfig.comboMultiplier;
    }

    final pts = (egg.points * _gs.multiplier).toInt();
    _gs.score += pts;

    final label = pts > egg.points ? '+$pts 🔥' : '+$pts';
    final color = egg.type == EggType.golden ? AppColors.secondary : Colors.greenAccent;
    _addPopup(label, color, egg.x, egg.y);
  }

  void _handleMiss(EggModel egg) {
    if (!egg.isGood) return; // missing bad eggs is fine
    _gs.combo = 0;
    _gs.multiplier = 1.0;
    _loseLife();
  }

  void _loseLife() {
    _gs.lives--;
    if (_gs.lives <= 0) _triggerGameOver();
  }

  void _addPopup(String text, Color color, double x, double y) {
    _popups.add(_ScorePopup(text: text, color: color, x: x, y: y, time: DateTime.now()));
  }

  // ── Game flow ─────────────────────────────────────────────────────────────

  void _pauseGame() {
    _stopTimers();
    AudioService.instance.pauseMusic();
    setState(() => _gs.state = GameState.paused);
  }

  void _resumeGame() {
    AudioService.instance.resumeMusic();
    setState(() => _gs.state = GameState.playing);
    _startGame();
  }

  void _restartGame() {
    _stopTimers();
    _fallSpeed = GameConfig.initialFallSpeed;
    _spawnIntervalMs = GameConfig.spawnInterval;
    _eggCounter = 0;
    _popups.clear();
    _gs = GameStateModel(mode: widget.mode);
    _basketX = _screenWidth / 2;
    AudioService.instance.resumeMusic();
    _startGame();
    setState(() {});
  }

  Future<void> _triggerGameOver() async {
    _stopTimers();
    bool isNewRecord = false;
    if (widget.mode == GameMode.classic) {
      isNewRecord = await ScoreService.instance.saveClassicScore(_gs.score);
    } else {
      isNewRecord = await ScoreService.instance.saveTimeAttackScore(_gs.score);
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => GameOverScreen(
          score: _gs.score,
          mode: widget.mode,
          isNewRecord: isNewRecord,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ── Drag control ──────────────────────────────────────────────────────────

  void _onDragUpdate(DragUpdateDetails details) {
    if (_gs.state != GameState.playing) return;
    setState(() {
      double speed = _gs.isFrozen ? 0.5 : 1.0;
      _basketX = (_basketX + details.delta.dx * speed)
          .clamp(AppSizes.basketWidth / 2, _screenWidth - AppSizes.basketWidth / 2);
    });
  }

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      body: GestureDetector(
        onHorizontalDragUpdate: _onDragUpdate,
        onPanUpdate: _onDragUpdate,
        child: Stack(
          children: [
            // Game background
            _GameBackground(),

            // Eggs
            ..._gs.eggs.map((egg) => Positioned(
              left: egg.x,
              top: egg.y,
              child: EggWidget(egg: egg),
            )),

            // Score popups
            ..._popups.map((p) => _ScorePopupWidget(popup: p)),

            // Basket
            Positioned(
              left: _basketX - AppSizes.basketWidth / 2,
              bottom: 16,
              child: BasketWidget(isFrozen: _gs.isFrozen),
            ),

            // HUD
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: HudWidget(state: _gs, onPause: _pauseGame),
              ),
            ),

            // Ground line
            Positioned(
              bottom: AppSizes.basketHeight + 10,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                color: Colors.white10,
              ),
            ),

            // Pause overlay
            if (_gs.state == GameState.paused)
              PauseOverlay(
                onResume: _resumeGame,
                onRestart: _restartGame,
                onMainMenu: () {
                  AudioService.instance.resumeMusic();
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _GameBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1B3E), Color(0xFF1A0A2E), Color(0xFF0D2018)],
        ),
      ),
      child: Stack(
        children: [
          // Stars
          for (int i = 0; i < 30; i++)
            Positioned(
              left: (i * 47 % 400).toDouble(),
              top: (i * 83 % 700).toDouble(),
              child: Container(
                width: i % 3 == 0 ? 3 : 2,
                height: i % 3 == 0 ? 3 : 2,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white38,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScorePopup {
  final String text;
  final Color color;
  final double x;
  final double y;
  final DateTime time;
  _ScorePopup({
    required this.text, required this.color,
    required this.x, required this.y, required this.time,
  });
}

class _ScorePopupWidget extends StatelessWidget {
  final _ScorePopup popup;
  const _ScorePopupWidget({required this.popup});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: popup.x,
      top: popup.y - 20,
      child: IgnorePointer(
        child: Text(
          popup.text,
          style: TextStyle(
            color: popup.color,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            shadows: [Shadow(color: Colors.black, offset: const Offset(1, 1), blurRadius: 4)],
          ),
        )
            .animate()
            .fadeIn(duration: 150.ms)
            .moveY(begin: 0, end: -40, duration: 800.ms, curve: Curves.easeOut)
            .fadeOut(delay: 500.ms, duration: 300.ms),
      ),
    );
  }
}