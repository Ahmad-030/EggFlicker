// lib/screens/gameover_screen.dart

import 'package:eggflicker/score_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'constants.dart';
import 'game_screen.dart';
import 'menu_screen.dart';

class GameOverScreen extends StatefulWidget {
  final int score;
  final GameMode mode;
  final bool isNewRecord;

  const GameOverScreen({
    super.key,
    required this.score,
    required this.mode,
    required this.isNewRecord,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final hs = widget.mode == GameMode.classic
        ? await ScoreService.instance.getClassicHighScore()
        : await ScoreService.instance.getTimeAttackHighScore();
    setState(() => _highScore = hs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF3D0B1A), Color(0xFF1A0A2E)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Emoji
                  const Text('💔', style: TextStyle(fontSize: 64))
                      .animate()
                      .scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.elasticOut)
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 16),

                  const Text(
                    'Game Over!',
                    style: TextStyle(
                      color: AppColors.livesRed,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 32),

                  // Score card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.isNewRecord ? AppColors.secondary : Colors.white12,
                        width: widget.isNewRecord ? 2 : 1,
                      ),
                      boxShadow: widget.isNewRecord
                          ? [BoxShadow(color: AppColors.secondary.withOpacity(0.3), blurRadius: 20)]
                          : [],
                    ),
                    child: Column(
                      children: [
                        if (widget.isNewRecord) ...[
                          const Text('🏆 NEW RECORD!',
                              style: TextStyle(color: AppColors.secondary, fontSize: 14, fontWeight: FontWeight.bold))
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .fadeIn(duration: 500.ms),
                          const SizedBox(height: 8),
                        ],

                        Text(
                          '${widget.score}',
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                            .animate(delay: 400.ms)
                            .fadeIn(duration: 500.ms)
                            .scale(begin: const Offset(0.7, 0.7), curve: Curves.elasticOut),

                        const Text('YOUR SCORE',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 2)),

                        const Divider(color: Colors.white12, height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Best Score', style: TextStyle(color: AppColors.textSecondary)),
                            Text(
                              '$_highScore',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Mode', style: TextStyle(color: AppColors.textSecondary)),
                            Text(
                              widget.mode == GameMode.classic ? '🎮 Classic' : '⏱️ Time Attack',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                      .animate(delay: 350.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 32),

                  // Buttons
                  _GOBtn(
                    label: '🔄  Play Again',
                    color: AppColors.primary,
                    delay: 600.ms,
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => GameScreen(mode: widget.mode)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GOBtn(
                    label: '🏠  Main Menu',
                    color: AppColors.cardBg,
                    delay: 720.ms,
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MenuScreen()),
                          (r) => false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GOBtn extends StatelessWidget {
  final String label;
  final Color color;
  final Duration delay;
  final VoidCallback onTap;

  const _GOBtn({required this.label, required this.color, required this.delay, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}