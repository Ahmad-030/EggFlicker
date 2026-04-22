// lib/screens/about_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [Color(0xFF1A3A1A), Color(0xFF1A0A2E)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App bar
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                    ),
                    const Text('About', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  ],
                ),

                const SizedBox(height: 24),

                // Lottie animation
                SizedBox(
                  width: 180,
                  height: 180,
                  child: Lottie.asset(
                    'assets/Hatch.json',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Text('🐔', style: TextStyle(fontSize: 80)),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.7, 0.7), duration: 700.ms, curve: Curves.elasticOut),

                const SizedBox(height: 16),

                Text(
                  AppStrings.appName,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3, end: 0),


                const SizedBox(height: 28),

                // How to play card
                _InfoCard(
                  title: '🎮 How to Play',
                  delay: 400.ms,
                  content: [
                    '🥚 Drag to move your basket left and right',
                    '⚪ Catch Normal Eggs for +1 point',
                    '🟡 Catch Golden Eggs for +5 points',
                    '🔴 Avoid Rotten Eggs — they cost you a life',
                    '💣 Never catch Bomb Eggs — instant 2 lives lost!',
                    '❄️ Frozen Eggs slow your basket for 3 seconds',
                    '🔥 5 catches in a row = 2x score multiplier',
                    '❤️ You start with 3 lives — don\'t waste them!',
                  ],
                ),

                const SizedBox(height: 16),

                // Developer card
                _InfoCard(
                  title: '👨‍💻 Developer',
                  delay: 600.ms,
                  content: [
                    'Name: ${AppStrings.developerName}',
                    'Email: ${AppStrings.developerEmail}',
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<String> content;
  final Duration delay;

  const _InfoCard({required this.title, required this.content, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...content.map((line) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(line, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
          )),
        ],
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }
}