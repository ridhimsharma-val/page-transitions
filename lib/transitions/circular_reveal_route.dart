import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom PageRouteBuilder that creates an expanding circular reveal transition
/// originating from a specific anchor point (or screen center if omitted).
///
/// Configured for Design 05 with:
/// - Forward duration: 900 ms, Curve: Curves.easeInOutCubic
/// - Reverse duration: 650 ms, Curve: Curves.easeInOutCubic
/// - Non-opaque route (`opaque: false`) allowing the underlying Explore screen
///   to remain visible outside the circular aperture during the transition.
/// - Dynamic coordinate space conversion from global to route-local coordinates.
/// - Circular clipping starting at ~1px expanding to farthest corner + 3px safety margin.
class CircularRevealPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Offset? origin;
  final Duration? transitionDurationOverride;
  final Duration? reverseTransitionDurationOverride;
  final Curve curve;
  final Curve reverseCurve;
  final bool showRing;

  CircularRevealPageRoute({
    required this.page,
    this.origin,
    this.transitionDurationOverride,
    this.reverseTransitionDurationOverride,
    this.curve = Curves.easeInOutCubic,
    this.reverseCurve = Curves.easeInOutCubic,
    this.showRing = false,
    super.opaque = false,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration:
              transitionDurationOverride ?? const Duration(milliseconds: 900),
          reverseTransitionDuration: reverseTransitionDurationOverride ??
              const Duration(milliseconds: 650),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
              reverseCurve: reverseCurve,
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
                Offset revealOrigin;
                if (origin != null) {
                  final routeBox = context.findRenderObject() as RenderBox?;
                  if (routeBox != null && routeBox.hasSize) {
                    revealOrigin = routeBox.globalToLocal(origin);
                  } else {
                    revealOrigin = origin;
                  }
                } else {
                  revealOrigin = Offset(screenSize.width / 2, screenSize.height / 2);
                }

                return AnimatedBuilder(
                  animation: curvedAnimation,
                  builder: (context, _) {
                    return Stack(
                      children: [
                        ClipPath(
                          clipper: CircularRevealClipper(
                            progress: curvedAnimation.value,
                            origin: revealOrigin,
                            minRadius: 1.0,
                            safetyMargin: 3.0,
                          ),
                          child: child,
                        ),
                        // Optional visual shockwave ring at the expanding boundary
                        if (showRing && curvedAnimation.value > 0.02 && curvedAnimation.value < 0.98)
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
  final double minRadius;
  final double safetyMargin;

  CircularRevealClipper({
    required this.progress,
    required this.origin,
    this.minRadius = 1.0,
    this.safetyMargin = 3.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    if (progress <= 0.0) {
      return path; // Empty - nothing revealed yet
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
    final maxRadius = [d1, d2, d3, d4].reduce(math.max) + safetyMargin;

    // Start with a small radius of ~1 px, expanding smoothly to full cover
    final currentRadius = minRadius + (maxRadius - minRadius) * progress;
    path.addOval(Rect.fromCircle(center: origin, radius: currentRadius));
    return path;
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return oldClipper.progress != progress ||
        oldClipper.origin != origin ||
        oldClipper.minRadius != minRadius ||
        oldClipper.safetyMargin != safetyMargin;
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
