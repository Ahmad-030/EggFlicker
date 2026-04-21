// lib/widgets/egg_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'constants.dart';
import 'egg_model.dart';

class EggWidget extends StatelessWidget {
  final EggModel egg;
  final bool exploding;

  const EggWidget({super.key, required this.egg, this.exploding = false});

  Color get _color {
    switch (egg.type) {
      case EggType.normal: return AppColors.eggNormal;
      case EggType.golden: return AppColors.eggGolden;
      case EggType.rotten: return AppColors.eggRotten;
      case EggType.bomb:   return AppColors.eggBomb;
      case EggType.frozen: return AppColors.eggFrozen;
    }
  }

  String get _emoji {
    switch (egg.type) {
      case EggType.normal: return '🥚';
      case EggType.golden: return '✨';
      case EggType.rotten: return '🤢';
      case EggType.bomb:   return '💣';
      case EggType.frozen: return '❄️';
    }
  }

  String get _label {
    switch (egg.type) {
      case EggType.normal: return '';
      case EggType.golden: return '+5';
      case EggType.rotten: return '-3';
      case EggType.bomb:   return '💥';
      case EggType.frozen: return '🧊';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget eggBody = CustomPaint(
      size: const Size(AppSizes.eggWidth, AppSizes.eggHeight),
      painter: _EggPainter(color: _color, type: egg.type),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_emoji, style: const TextStyle(fontSize: 18)),
            if (_label.isNotEmpty)
              Text(
                _label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: egg.type == EggType.golden ? Colors.orange.shade900 : Colors.white,
                ),
              ),
          ],
        ),
      ),
    );

    if (egg.type == EggType.golden) {
      eggBody = eggBody
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(duration: 1200.ms, color: Colors.white54);
    }

    return eggBody;
  }
}

class _EggPainter extends CustomPainter {
  final Color color;
  final EggType type;
  _EggPainter({required this.color, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 0.8,
        colors: [color.withOpacity(0.95), color.withOpacity(0.65)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..cubicTo(
          -size.width * 0.05, size.height,
          -size.width * 0.05, size.height * 0.55,
          size.width / 2, size.height * 0.1)
      ..cubicTo(
          size.width * 1.05, size.height * 0.55,
          size.width * 1.05, size.height,
          size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Outline
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withOpacity(0.3);
    canvas.drawPath(path, outlinePaint);

    // Shine
    final shinePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.35);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(size.width * 0.35, size.height * 0.28),
          width: size.width * 0.22,
          height: size.height * 0.13),
      shinePaint,
    );
  }

  @override
  bool shouldRepaint(_EggPainter old) => old.color != color;
}