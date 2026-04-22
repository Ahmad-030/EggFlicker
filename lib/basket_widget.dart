// lib/basket_widget.dart

import 'package:flutter/material.dart';

class BasketWidget extends StatelessWidget {
  final bool isFrozen;
  const BasketWidget({super.key, this.isFrozen = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 44,
      child: CustomPaint(
        painter: _BasketPainter(isFrozen: isFrozen),
        child: isFrozen
            ? const Center(
          child: Text('❄️', style: TextStyle(fontSize: 18)),
        )
            : null,
      ),
    );
  }
}

class _BasketPainter extends CustomPainter {
  final bool isFrozen;
  _BasketPainter({required this.isFrozen});

  @override
  void paint(Canvas canvas, Size size) {
    final Color rimColor =
    isFrozen ? const Color(0xFF00E5FF) : const Color(0xFFFFD700);
    final Color bodyTop =
    isFrozen ? const Color(0xFF0097A7) : const Color(0xFFFF6B35);
    final Color bodyBot =
    isFrozen ? const Color(0xFF004D61) : const Color(0xFF8B2500);

    // ── Drop shadow ────────────────────────────────────────────
    final shadowPaint = Paint()
      ..color = Colors.black54
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final shadowPath = Path()
      ..moveTo(8, 6)
      ..lineTo(size.width - 4, 6)
      ..lineTo(size.width + 2, size.height + 4)
      ..lineTo(2, size.height + 4)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);

    // ── Body (trapezoid) ───────────────────────────────────────
    final bodyPath = Path()
      ..moveTo(4, 0)
      ..lineTo(size.width - 4, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      bodyPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [bodyTop, bodyBot],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );

    // ── Weave grid ─────────────────────────────────────────────
    final gridPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0;

    // horizontal lines
    for (int i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      final leftX = 4 * (1 - i / 4);
      final rightX = size.width - 4 * (1 - i / 4);
      canvas.drawLine(Offset(leftX, y), Offset(rightX, y), gridPaint);
    }
    // vertical lines
    for (int i = 1; i <= 5; i++) {
      final t = i / 6;
      final xTop = 4 + (size.width - 8) * t;
      final xBot = size.width * t;
      canvas.drawLine(Offset(xTop, 0), Offset(xBot, size.height), gridPaint);
    }

    // ── White outline ──────────────────────────────────────────
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = Colors.white38
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // ── Rim (small radius) ─────────────────────────────────────
    final rimRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, -6, size.width, 12),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      rimRect,
      Paint()
        ..color = rimColor
        ..style = PaintingStyle.fill,
    );

    // Rim shine strip
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.08, -5, size.width * 0.38, 5),
        const Radius.circular(3),
      ),
      Paint()..color = Colors.white54,
    );

    // Rim outline
    canvas.drawRRect(
      rimRect,
      Paint()
        ..color = Colors.white30
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(_BasketPainter old) => old.isFrozen != isFrozen;
}