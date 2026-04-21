// lib/widgets/basket_widget.dart

import 'package:flutter/material.dart';
import 'constants.dart';

class BasketWidget extends StatelessWidget {
  final bool isFrozen;
  const BasketWidget({super.key, this.isFrozen = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(AppSizes.basketWidth, AppSizes.basketHeight),
      painter: _BasketPainter(isFrozen: isFrozen),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: isFrozen
              ? const Text('❄️', style: TextStyle(fontSize: 20))
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _BasketPainter extends CustomPainter {
  final bool isFrozen;
  _BasketPainter({required this.isFrozen});

  @override
  void paint(Canvas canvas, Size size) {
    final basketColor = isFrozen ? AppColors.eggFrozen : AppColors.primary;
    final rimColor = isFrozen ? const Color(0xFF4DD0E1) : AppColors.secondary;

    // Basket body (trapezoid)
    final bodyPath = Path()
      ..moveTo(size.width * 0.05, 0)
      ..lineTo(size.width * 0.95, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [basketColor.withOpacity(0.9), basketColor.withOpacity(0.6)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(bodyPath, bodyPaint);

    // Weave lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.2;
    for (int i = 1; i < 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    for (int i = 1; i < 6; i++) {
      final x = size.width * (i / 6);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Rim
    final rimPaint = Paint()
      ..color = rimColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(0, -6, size.width, 14), const Radius.circular(7)),
      rimPaint,
    );

    // Outline
    final outlinePaint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(bodyPath, outlinePaint);
  }

  @override
  bool shouldRepaint(_BasketPainter old) => old.isFrozen != isFrozen;
}