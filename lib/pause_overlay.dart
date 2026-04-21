// lib/widgets/pause_overlay.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'audio_service.dart';
import 'constants.dart';

class PauseOverlay extends StatefulWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onMainMenu;

  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onMainMenu,
  });

  @override
  State<PauseOverlay> createState() => _PauseOverlayState();
}

class _PauseOverlayState extends State<PauseOverlay> {
  bool _musicEnabled = AudioService.instance.musicEnabled;

  void _toggleMusic() async {
    await AudioService.instance.toggleMusic();
    setState(() => _musicEnabled = AudioService.instance.musicEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.78),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 30, spreadRadius: 2)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⏸ Paused',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 24),

              // Music toggle
              GestureDetector(
                onTap: _toggleMusic,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _musicEnabled ? Icons.music_note_rounded : Icons.music_off_rounded,
                        color: _musicEnabled ? AppColors.secondary : Colors.white38,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _musicEnabled ? 'Music: ON' : 'Music: OFF',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _PauseBtn(label: '▶  Resume', color: AppColors.primary, onTap: widget.onResume),
              const SizedBox(height: 12),
              _PauseBtn(label: '🔄  Restart', color: const Color(0xFF7C3AED), onTap: widget.onRestart),
              const SizedBox(height: 12),
              _PauseBtn(label: '🏠  Main Menu', color: Colors.white24, onTap: widget.onMainMenu),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .scale(begin: const Offset(0.85, 0.85), duration: 350.ms, curve: Curves.elasticOut),
      ),
    );
  }
}

class _PauseBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _PauseBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ),
    );
  }
}