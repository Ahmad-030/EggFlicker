// lib/widgets/egg_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'constants.dart';
import 'egg_model.dart';

class EggWidget extends StatelessWidget {
  final EggModel egg;
  final bool exploding;

  const EggWidget({super.key, required this.egg, this.exploding = false});

  Color get _baseColor {
    switch (egg.type) {
      case EggType.normal: return const Color(0xFFFFF8F0);
      case EggType.golden: return const Color(0xFFFFD700);
      case EggType.rotten: return const Color(0xFF66BB6A);
      case EggType.bomb:   return const Color(0xFF212121);
      case EggType.frozen: return const Color(0xFF80DEEA);
    }
  }

  Color get _glowColor {
    switch (egg.type) {
      case EggType.normal: return Colors.white;
      case EggType.golden: return const Color(0xFFFFA000);
      case EggType.rotten: return const Color(0xFF2E7D32);
      case EggType.bomb:   return const Color(0xFFFF5722);
      case EggType.frozen: return const Color(0xFF00BCD4);
    }
  }

  String get _emoji {
    switch (egg.type) {
      case EggType.normal: return '🥚';
      case EggType.golden: return '⭐';
      case EggType.rotten: return '🤢';
      case EggType.bomb:   return '💣';
      case EggType.frozen: return '❄️';
    }
  }

  String get _label {
    switch (egg.type) {
      case EggType.normal: return '+1';
      case EggType.golden: return '+5';
      case EggType.rotten: return '-3';
      case EggType.bomb:   return '-2❤';
      case EggType.frozen: return 'SLOW';
    }
  }

  Color get _labelColor {
    switch (egg.type) {
      case EggType.normal: return Colors.greenAccent;
      case EggType.golden: return Colors.orange.shade900;
      case EggType.rotten: return Colors.red.shade300;
      case EggType.bomb:   return Colors.redAccent;
      case EggType.frozen: return Colors.cyan.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget eggBody = SizedBox(
      width: AppSizes.eggWidth,
      height: AppSizes.eggHeight + 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glow + egg shape
          Container(
            width: AppSizes.eggWidth,
            height: AppSizes.eggHeight,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: _glowColor.withOpacity(0.6),
                  blurRadius: 14,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CustomPaint(
              size: const Size(AppSizes.eggWidth, AppSizes.eggHeight),
              painter: _EggPainter(baseColor: _baseColor, type: egg.type),
              child: Center(
                child: Text(
                  _emoji,
                  style: TextStyle(
                    fontSize: egg.type == EggType.bomb ? 22 : 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          // Label badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _glowColor.withOpacity(0.6), width: 1),
            ),
            child: Text(
              _label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: _labelColor,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );

    // Golden egg shimmer
    if (egg.type == EggType.golden) {
      eggBody = eggBody
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(duration: 1000.ms, color: Colors.white60)
          .scale(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.06, 1.06),
        duration: 800.ms,
        curve: Curves.easeInOut,
      );
    }

    // Bomb pulse
    if (egg.type == EggType.bomb) {
      eggBody = eggBody
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.08, 1.08),
        duration: 500.ms,
        curve: Curves.easeInOut,
      );
    }

    // Frozen shimmer
    if (egg.type == EggType.frozen) {
      eggBody = eggBody
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(duration: 1400.ms, color: Colors.cyan.withOpacity(0.5));
    }

    return eggBody;
  }
}

class _EggPainter extends CustomPainter {
  final Color baseColor;
  final EggType type;
  _EggPainter({required this.baseColor, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    // Egg shape path
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..cubicTo(
          -size.width * 0.05, size.height,
          -size.width * 0.05, size.height * 0.55,
          size.width / 2, size.height * 0.08)
      ..cubicTo(
          size.width * 1.05, size.height * 0.55,
          size.width * 1.05, size.height,
          size.width / 2, size.height)
      ..close();

    // Determine gradient colors
    Color topColor;
    Color bottomColor;
    switch (type) {
      case EggType.normal:
        topColor = const Color(0xFFFFFDE7);
        bottomColor = const Color(0xFFD7B89C);
        break;
      case EggType.golden:
        topColor = const Color(0xFFFFF176);
        bottomColor = const Color(0xFFE65100);
        break;
      case EggType.rotten:
        topColor = const Color(0xFFA5D6A7);
        bottomColor = const Color(0xFF1B5E20);
        break;
      case EggType.bomb:
        topColor = const Color(0xFF424242);
        bottomColor = const Color(0xFF000000);
        break;
      case EggType.frozen:
        topColor = const Color(0xFFE0F7FA);
        bottomColor = const Color(0xFF006064);
        break;
    }

    final bodyPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [topColor, bottomColor],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, bodyPaint);

    // Outline
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = Colors.white.withOpacity(type == EggType.bomb ? 0.15 : 0.45);
    canvas.drawPath(path, outlinePaint);

    // Specular highlight (top-left shine)
    final shinePath = Path()
      ..moveTo(size.width * 0.28, size.height * 0.13)
      ..cubicTo(
          size.width * 0.18, size.height * 0.18,
          size.width * 0.15, size.height * 0.30,
          size.width * 0.25, size.height * 0.35)
      ..cubicTo(
          size.width * 0.35, size.height * 0.30,
          size.width * 0.40, size.height * 0.18,
          size.width * 0.28, size.height * 0.13)
      ..close();

    final shinePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(type == EggType.bomb ? 0.08 : 0.50);
    canvas.drawPath(shinePath, shinePaint);

    // Small round highlight dot
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(type == EggType.bomb ? 0.1 : 0.70);
    canvas.drawCircle(
        Offset(size.width * 0.30, size.height * 0.17), size.width * 0.07, dotPaint);

    // Rotten spots
    if (type == EggType.rotten) {
      final spotPaint = Paint()
        ..color = const Color(0xFF1B5E20).withOpacity(0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.45), 5, spotPaint);
      canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.65), 4, spotPaint);
      canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.7), 3, spotPaint);
    }

    // Frozen cracks
    if (type == EggType.frozen) {
      final crackPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.25),
          Offset(size.width * 0.62, size.height * 0.45),
          crackPaint);
      canvas.drawLine(
          Offset(size.width * 0.62, size.height * 0.45),
          Offset(size.width * 0.55, size.height * 0.58),
          crackPaint);
    }

    // Bomb fuse spark
    if (type == EggType.bomb) {
      final sparkPaint = Paint()
        ..color = const Color(0xFFFF9800)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.08),
          Offset(size.width * 0.65, size.height * -0.05),
          sparkPaint);
      // Spark glow
      final glowPaint = Paint()
        ..color = const Color(0xFFFFEB3B)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(
          Offset(size.width * 0.65, size.height * -0.05), 4, glowPaint);
    }
  }

  @override
  bool shouldRepaint(_EggPainter old) => old.baseColor != baseColor;
}