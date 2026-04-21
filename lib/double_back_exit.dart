// lib/utils/double_back_exit.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wrap any Scaffold body with [DoubleBackToExit] to show a confirmation
/// dialog when the user presses back twice (or once, showing dialog first).
class DoubleBackToExit extends StatelessWidget {
  final Widget child;
  const DoubleBackToExit({super.key, required this.child});

  Future<bool> _onWillPop(BuildContext context) async {
    final exit = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B4E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Exit Game?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to quit EggFlicker?',
          style: TextStyle(color: Color(0xFFB8A9C9)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Stay', style: TextStyle(color: Color(0xFF00E5FF))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B5C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    if (exit == true) SystemNavigator.pop();
    return false; // always return false; we handle exit ourselves
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onWillPop(context);
      },
      child: child,
    );
  }
}