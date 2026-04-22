// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'audio_service.dart';
import 'constants.dart';
import 'menu_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await AudioService.instance.init();
    await Future.delayed(const Duration(milliseconds: 3200));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const MenuScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/img.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.4,
                  colors: [Color(0xFF3D1A6E), Color(0xFF0D0520)],
                ),
              ),
            ),
          ),
          // Dark overlay
          Container(color: Colors.black38),

          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie hen animation
              SizedBox(
                width: 220,
                height: 220,
                child: Lottie.asset(
                  'assets/Hatch.json',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.egg_alt_rounded,
                    size: 120,
                    color: AppColors.secondary,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.7, 0.7), duration: 700.ms, curve: Curves.elasticOut),

              const SizedBox(height: 24),

              // Title
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  fontFamily: 'Fredoka One',
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                  shadows: [
                    Shadow(color: Color(0xFFFF6B35), offset: Offset(3, 3), blurRadius: 8),
                  ],
                  letterSpacing: 2,
                ),
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.4, end: 0, duration: 500.ms, curve: Curves.easeOut),

              const SizedBox(height: 8),

              Text(
                AppStrings.tagline,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              )
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 500.ms),

              const SizedBox(height: 48),

              // Loading dots
              _LoadingDots()
                  .animate(delay: 900.ms)
                  .fadeIn(duration: 400.ms),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.3;
            final t = (_ctrl.value - delay).clamp(0.0, 1.0);
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.2, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(opacity),
              ),
            );
          }),
        );
      },
    );
  }
}