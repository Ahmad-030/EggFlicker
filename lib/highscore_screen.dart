// lib/screens/highscore_screen.dart

import 'package:eggflicker/score_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'constants.dart';

class HighscoreScreen extends StatefulWidget {
  const HighscoreScreen({super.key});

  @override
  State<HighscoreScreen> createState() => _HighscoreScreenState();
}

class _HighscoreScreenState extends State<HighscoreScreen> {
  int _classicHigh = 0;
  int _timeAttackHigh = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await ScoreService.instance.getClassicHighScore();
    final t = await ScoreService.instance.getTimeAttackHighScore();
    setState(() {
      _classicHigh = c;
      _timeAttackHigh = t;
    });
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
            colors: [Color(0xFF1A2D5A), Color(0xFF1A0A2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                    ),
                    const Text(
                      '🏆 High Scores',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Trophy emoji
              const Text('🏆', style: TextStyle(fontSize: 80))
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1500.ms),

              const SizedBox(height: 32),

              // Classic card
              _ScoreCard(
                mode: '🎮 Classic Mode',
                score: _classicHigh,
                color: AppColors.primary,
                delay: 200.ms,
              ),

              const SizedBox(height: 20),

              // Time Attack card
              _ScoreCard(
                mode: '⏱️ Time Attack',
                score: _timeAttackHigh,
                color: const Color(0xFF7C3AED),
                delay: 400.ms,
              ),

              const SizedBox(height: 40),

              const Text(
                'Keep catching eggs to beat your record!',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ).animate(delay: 600.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String mode;
  final int score;
  final Color color;
  final Duration delay;

  const _ScoreCard({
    required this.mode,
    required this.score,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), AppColors.cardBg],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 16)],
        ),
        child: Column(
          children: [
            Text(mode, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, letterSpacing: 1)),
            const SizedBox(height: 8),
            Text(
              score == 0 ? '--' : '$score',
              style: TextStyle(
                color: score == 0 ? Colors.white24 : AppColors.secondary,
                fontSize: 52,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (score == 0)
              const Text('No score yet', style: TextStyle(color: Colors.white24, fontSize: 12)),
          ],
        ),
      )
          .animate(delay: delay)
          .fadeIn(duration: 500.ms)
          .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOut),
    );
  }
}