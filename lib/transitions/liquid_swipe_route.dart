import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom PageRouteBuilder that reveals the incoming screen with an organic liquid wave sweep
class LiquidSwipePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration transitionDurationOverride;

  LiquidSwipePageRoute({
    required this.page,
    this.transitionDurationOverride = const Duration(milliseconds: 850),
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: transitionDurationOverride,
          reverseTransitionDuration: Duration(
            milliseconds: (transitionDurationOverride.inMilliseconds * 0.85).round(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutQuart,
              reverseCurve: Curves.easeInOutCubic,
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);

                return AnimatedBuilder(
                  animation: curvedAnimation,
                  builder: (context, _) {
                    final progress = curvedAnimation.value;

                    return Stack(
                      children: [
                        ClipPath(
                          clipper: LiquidWaveClipper(progress: progress),
                          child: child,
                        ),
                        // Liquid crest glowing border
                        if (progress > 0.01 && progress < 0.99)
                          IgnorePointer(
                            child: CustomPaint(
                              size: size,
                              painter: _LiquidCrestPainter(progress: progress),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
}

/// Clipper generating dynamic fluid wave paths
class LiquidWaveClipper extends CustomClipper<Path> {
  final double progress;

  LiquidWaveClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final path = Path();

    if (progress <= 0.0) return path;
    if (progress >= 1.0) {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      return path;
    }

    // Base boundary position moving from right to left
    // Extra offset ensures wave tips start completely off-screen and finish fully across
    final baseProgress = (progress * 1.35) - 0.15;
    final baseX = size.width * (1.0 - baseProgress.clamp(0.0, 1.0));

    // Dynamic wave amplitude swells in the middle of transition
    final waveIntensity = math.sin(progress * math.pi);
    final amp1 = 80.0 * waveIntensity;
    final amp2 = 30.0 * waveIntensity;
    final phase = progress * math.pi * 3.0;

    path.moveTo(size.width, 0);

    const int steps = 40;
    for (int i = 0; i <= steps; i++) {
      final y = size.height * (i / steps);
      final normalizedY = y / size.height;

      // Complex fluid wave profile with primary and secondary harmonics
      final waveOffset = (amp1 * math.sin(normalizedY * 2.5 * math.pi + phase)) +
          (amp2 * math.cos(normalizedY * 4.0 * math.pi + phase * 1.5));

      final x = (baseX - waveOffset).clamp(0.0, size.width + 100);

      if (i == 0) {
        path.lineTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(LiquidWaveClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

class _LiquidCrestPainter extends CustomPainter {
  final double progress;

  _LiquidCrestPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final baseProgress = (progress * 1.35) - 0.15;
    final baseX = size.width * (1.0 - baseProgress.clamp(0.0, 1.0));

    final waveIntensity = math.sin(progress * math.pi);
    final amp1 = 80.0 * waveIntensity;
    final amp2 = 30.0 * waveIntensity;
    final phase = progress * math.pi * 3.0;

    final path = Path();
    const int steps = 40;

    for (int i = 0; i <= steps; i++) {
      final y = size.height * (i / steps);
      final normalizedY = y / size.height;

      final waveOffset = (amp1 * math.sin(normalizedY * 2.5 * math.pi + phase)) +
          (amp2 * math.cos(normalizedY * 4.0 * math.pi + phase * 1.5));

      final x = (baseX - waveOffset).clamp(0.0, size.width + 100);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFC4B5FD),
          Color(0xFF9B7BFF),
          Color(0xFF38BDF8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = Colors.white.withOpacity(0.9);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(_LiquidCrestPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
