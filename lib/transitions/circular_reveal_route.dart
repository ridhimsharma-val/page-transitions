import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom PageRouteBuilder that creates an expanding circular reveal transition
/// originating from a specific anchor point (or screen center if omitted).
class CircularRevealPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Offset? origin;
  final Duration transitionDurationOverride;

  CircularRevealPageRoute({
    required this.page,
    this.origin,
    this.transitionDurationOverride = const Duration(milliseconds: 700),
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
              curve: Curves.easeInOutCubicEmphasized,
              reverseCurve: Curves.easeInOutCubic,
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
                final revealOrigin = origin ?? Offset(screenSize.width / 2, screenSize.height / 2);

                return AnimatedBuilder(
                  animation: curvedAnimation,
                  builder: (context, _) {
                    return Stack(
                      children: [
                        ClipPath(
                          clipper: CircularRevealClipper(
                            progress: curvedAnimation.value,
                            origin: revealOrigin,
                          ),
                          child: child,
                        ),
                        // Visual shockwave ring at the expanding boundary
                        if (curvedAnimation.value > 0.02 && curvedAnimation.value < 0.98)
                          IgnorePointer(
                            child: CustomPaint(
                              size: screenSize,
                              painter: _CircularEdgeRingPainter(
                                origin: revealOrigin,
                                progress: curvedAnimation.value,
                              ),
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

class CircularRevealClipper extends CustomClipper<Path> {
  final double progress;
  final Offset origin;

  CircularRevealClipper({
    required this.progress,
    required this.origin,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    if (progress <= 0.0) {
      return path; // Empty
    }
    if (progress >= 1.0) {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      return path;
    }

    // Calculate maximum distance from origin to all 4 corners
    final d1 = (origin - Offset.zero).distance;
    final d2 = (origin - Offset(size.width, 0)).distance;
    final d3 = (origin - Offset(0, size.height)).distance;
    final d4 = (origin - Offset(size.width, size.height)).distance;
    final maxRadius = [d1, d2, d3, d4].reduce(math.max);

    final currentRadius = maxRadius * progress;
    path.addOval(Rect.fromCircle(center: origin, radius: currentRadius));
    return path;
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return oldClipper.progress != progress || oldClipper.origin != origin;
  }
}

class _CircularEdgeRingPainter extends CustomPainter {
  final Offset origin;
  final double progress;

  _CircularEdgeRingPainter({
    required this.origin,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final d1 = (origin - Offset.zero).distance;
    final d2 = (origin - Offset(size.width, 0)).distance;
    final d3 = (origin - Offset(0, size.height)).distance;
    final d4 = (origin - Offset(size.width, size.height)).distance;
    final maxRadius = [d1, d2, d3, d4].reduce(math.max);

    final currentRadius = maxRadius * progress;
    final opacity = (1.0 - progress).clamp(0.0, 1.0) * 0.7;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFC4B5FD).withOpacity(opacity),
          const Color(0xFF9B7BFF).withOpacity(opacity * 0.4),
          Colors.transparent,
        ],
        stops: const [0.85, 0.95, 1.0],
      ).createShader(
        Rect.fromCircle(center: origin, radius: currentRadius + 8),
      );

    canvas.drawCircle(origin, currentRadius, paint);
  }

  @override
  bool shouldRepaint(_CircularEdgeRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.origin != origin;
  }
}
