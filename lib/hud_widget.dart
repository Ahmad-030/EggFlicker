// lib/widgets/hud_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'constants.dart';
import 'game_state_model.dart';

class HudWidget extends StatelessWidget {
  final GameStateModel state;
  final VoidCallback onPause;

  const HudWidget({super.key, required this.state, required this.onPause});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          // Lives
          _LivesDisplay(lives: state.lives),

          const Spacer(),

          // Score + combo
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    '${state.score}',
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      shadows: [Shadow(color: Color(0xFFFF6B35), offset: Offset(1, 2), blurRadius: 6)],
                    ),
                  ),
                  if (state.multiplier > 1)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.comboGold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${state.multiplier.toInt()}x',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1.05, 1.05),
                        duration: 600.ms),
                ],
              ),
              if (state.combo >= 2)
                Text(
                  '${state.combo} Combo! 🔥',
                  style: const TextStyle(color: AppColors.comboGold, fontSize: 11, fontWeight: FontWeight.bold),
                ).animate().fadeIn(duration: 200.ms),
            ],
          ),

          const Spacer(),

          // Timer (Time Attack) or Pause button
          Row(
            children: [
              if (state.mode == GameMode.timeAttack)
                _TimerDisplay(secondsLeft: state.timeLeft),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onPause,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Icon(Icons.pause_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LivesDisplay extends StatelessWidget {
  final int lives;
  const _LivesDisplay({required this.lives});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(GameConfig.initialLives, (i) {
        final active = i < lives;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: active ? AppColors.livesRed : Colors.white24,
            size: 22,
          ),
        );
      }),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final int secondsLeft;
  const _TimerDisplay({required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    final urgent = secondsLeft <= 10;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: urgent ? AppColors.livesRed.withOpacity(0.3) : AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: urgent ? AppColors.livesRed : Colors.white12),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_rounded, color: urgent ? AppColors.livesRed : AppColors.accent, size: 16),
          const SizedBox(width: 4),
          Text(
            '$secondsLeft',
            style: TextStyle(
              color: urgent ? AppColors.livesRed : AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}