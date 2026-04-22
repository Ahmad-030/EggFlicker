// lib/screens/menu_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import 'audio_service.dart';
import 'constants.dart';
import 'double_back_exit.dart';
import 'game_screen.dart';
import 'highscore_screen.dart';
import 'about_screen.dart';
import 'privacy_policy_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _musicEnabled = AudioService.instance.musicEnabled;

  void _toggleMusic() async {
    await AudioService.instance.toggleMusic();
    setState(() => _musicEnabled = AudioService.instance.musicEnabled);
  }

  void _startGame(GameMode mode) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => GameScreen(mode: mode),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/img_1.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2D0B55), Color(0xFF0D1B3E), Color(0xFF1A0A2E)],
                  ),
                ),
              ),
            ),
            Container(color: Colors.black.withOpacity(0.45)),

            // Decorative floating eggs
            ..._buildFloatingEggs(),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Top bar: music toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _MusicToggleButton(
                          enabled: _musicEnabled,
                          onTap: _toggleMusic,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Lottie hen
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Lottie.asset(
                      'assets/Hatch.json',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.egg_alt_rounded,
                        size: 100,
                        color: AppColors.secondary,
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: 0, end: -12, duration: 1800.ms, curve: Curves.easeInOut),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    AppStrings.appName,
                    style: const TextStyle(
                      fontFamily: 'Fredoka One',
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondary,
                      shadows: [
                        Shadow(color: Color(0xFFFF6B35), offset: Offset(3, 4), blurRadius: 10),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.8, 0.8), duration: 600.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 4),
                  const Text(
                    AppStrings.tagline,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 15, letterSpacing: 1),
                  ).animate(delay: 200.ms).fadeIn(),

                  const SizedBox(height: 36),

                  // Mode buttons
                  _MenuButton(
                    label: '🎮  Classic Mode',
                    subtitle: 'Infinite — beat your best!',
                    color: AppColors.primary,
                    delay: 300.ms,
                    onTap: () => _startGame(GameMode.classic),
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    label: '⏱️  Time Attack',
                    subtitle: '60 seconds — score as much as you can!',
                    color: const Color(0xFF7C3AED),
                    delay: 420.ms,
                    onTap: () => _startGame(GameMode.timeAttack),
                  ),

                  const SizedBox(height: 30),

                  // Secondary buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _IconMenuBtn(
                        icon: Icons.leaderboard_rounded,
                        label: 'Scores',
                        delay: 540.ms,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const HighscoreScreen()),
                        ),
                      ),
                      const SizedBox(width: 20),
                      _IconMenuBtn(
                        icon: Icons.info_outline_rounded,
                        label: 'About',
                        delay: 620.ms,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AboutScreen()),
                        ),
                      ),
                      const SizedBox(width: 20),
                      _IconMenuBtn(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy',
                        delay: 700.ms,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Text(
                    'Made with ❤️  by ${AppStrings.developerName}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ).animate(delay: 800.ms).fadeIn(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingEggs() {
    final positions = [
      [0.05, 0.08], [0.88, 0.12], [0.15, 0.85],
      [0.78, 0.78], [0.50, 0.04], [0.92, 0.50],
    ];
    final emojis = ['🥚', '🌟', '🥚', '💎', '🌟', '🥚'];
    return List.generate(positions.length, (i) {
      return Positioned(
        left: MediaQuery.of(context).size.width * positions[i][0],
        top: MediaQuery.of(context).size.height * positions[i][1],
        child: Text(emojis[i], style: const TextStyle(fontSize: 28))
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(
          begin: 0,
          end: -20,
          delay: Duration(milliseconds: i * 300),
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOut,
        )
            .fadeIn(delay: Duration(milliseconds: i * 150)),
      );
    });
  }
}

// ── Widgets ────────────────────────────────────────────────────────────────

class _MenuButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final Duration delay;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        )
            .animate()
            .scale(begin: const Offset(0.95, 0.95), duration: 180.ms)
            .animate(delay: delay)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut),
      ),
    );
  }
}

class _IconMenuBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Duration delay;
  final VoidCallback onTap;

  const _IconMenuBtn({
    required this.icon,
    required this.label,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accent, size: 26),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      )
          .animate(delay: delay)
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut),
    );
  }
}

class _MusicToggleButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;
  const _MusicToggleButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(
          enabled ? Icons.music_note_rounded : Icons.music_off_rounded,
          color: enabled ? AppColors.secondary : Colors.white38,
          size: 22,
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}