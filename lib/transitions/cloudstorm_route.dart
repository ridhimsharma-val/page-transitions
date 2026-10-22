import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Scope providing the route animation to descendants in Design 06 — Cloudstorm Reveal.
class CloudstormScope extends InheritedWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  const CloudstormScope({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required super.child,
  });

  static CloudstormScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CloudstormScope>();
  }

  @override
  bool updateShouldNotify(CloudstormScope oldWidget) {
    return animation != oldWidget.animation ||
        secondaryAnimation != oldWidget.secondaryAnimation;
  }
}

/// A high-performance, GPU-accelerated painter implementing an airy, multi-ribbon
/// Himalayan mountain mist transition with delicate intensity and organic flow.
///
/// Features 3 distinct, soft-edged organic cloud ribbons + a subtle atmospheric mist haze:
/// - **Ribbon 1 (High Ridge Mist)**: Wispy, fast-drifting upper ridge clouds (~22% of screen).
/// - **Ribbon 2 (Mid Alpine Wisp Bank)**: Soft, billowy mountain cloud wisp (~48% of screen).
/// - **Ribbon 3 (Lower Slope Fog)**: Gentle low-altitude valley fog drifting along lower slopes (~76% of screen).
/// - **Atmospheric Mist Haze**: Delicate sheer wash giving an airy mountain softening without heavy opaque blanketing.
///
/// Contours are generated using multi-frequency deterministic harmonic noise to prevent
/// repetitive geometric or water-like wave patterns. Edges are feathered with smooth
/// linear gradients in pure white (`#FFFFFF`), snow mist (`#F8FAFC`), pale slate (`#F1F5F9`),
/// and soft lavender tones (`#EDE9FE`).
class CloudstormPainter extends CustomPainter {
  final double progress;

  CloudstormPainter({required this.progress});

  /// Evaluates deterministic multi-octave harmonic noise at position [x] with [seed].
  ///
  /// Combines four non-harmonic frequencies to produce natural, continuously
  /// differentiable pseudo-fractal billows and wisps in the range [-1.0, 1.0].
  static double _noise(double x, double seed) {
    final double n1 = math.sin(x * 0.0031 + seed * 1.73);
    final double n2 = math.sin(x * 0.0078 + seed * 3.17 + 1.25) * 0.55;
    final double n3 = math.cos(x * 0.0162 + seed * 5.41 + 2.37) * 0.28;
    final double n4 = math.sin(x * 0.0345 + seed * 7.89 + 0.82) * 0.14;
    return (n1 + n2 + n3 + n4) / 1.97;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) {
      return;
    }

    final double w = size.width;
    final double h = size.height;

    // =========================================================================
    // LAYER 0: Sheer Atmospheric Mist Haze
    // Provides gentle, airy softening across the transition without dense blanketing.
    // =========================================================================
    final double blanketIn = const Interval(0.20, 0.48, curve: Curves.easeOutCubic)
        .transform(progress.clamp(0.0, 1.0));
    final double blanketOut = 1.0 -
        const Interval(0.60, 0.88, curve: Curves.easeInCubic)
            .transform(progress.clamp(0.0, 1.0));
    final double blanketOpacity = (blanketIn * blanketOut).clamp(0.0, 1.0);

    if (blanketOpacity > 0.005) {
      final double blanketSweep = const Interval(0.10, 0.90, curve: Curves.easeInOutCubic)
          .transform(progress.clamp(0.0, 1.0));
      final double blanketX = -w * 0.35 + (w * 0.70 * blanketSweep);

      final blanketPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0x00FFFFFF),
            const Color(0xFFF8FAFC).withValues(alpha: blanketOpacity * 0.22),
            Colors.white.withValues(alpha: blanketOpacity * 0.35),
            const Color(0xFFF1F5F9).withValues(alpha: blanketOpacity * 0.28),
            const Color(0xFFEDE9FE).withValues(alpha: blanketOpacity * 0.16),
            const Color(0x00FFFFFF),
          ],
          stops: const [0.0, 0.15, 0.45, 0.70, 0.88, 1.0],
        ).createShader(Rect.fromLTWH(blanketX, 0, w * 1.8, h));

      canvas.drawRect(Rect.fromLTWH(0, 0, w, h), blanketPaint);
    }

    // =========================================================================
    // RIBBON 1: High Ridge Mist (Upper Peaks: ~22% of screen)
    // Wispy, high-velocity drift across the upper mountain peaks.
    // =========================================================================
    _paintNoiseRibbon(
      canvas: canvas,
      screenSize: size,
      baseYRatio: 0.22,
      nominalHeight: h * 0.18,
      topAmplitude: h * 0.06,
      bottomAmplitude: h * 0.05,
      topSeed: 11.3,
      bottomSeed: 19.7,
      intervalIn: const Interval(0.00, 0.36, curve: Curves.easeOutCubic),
      intervalOut: const Interval(0.55, 0.84, curve: Curves.easeInCubic),
      sweepInterval: const Interval(0.05, 0.82, curve: Curves.easeInOutCubic),
      speedFactor: 1.15,
      opacityFactor: 0.58,
      primaryColor: Colors.white,
      tintColor: const Color(0xFFF8FAFC),
    );

    // =========================================================================
    // RIBBON 2: Mid Alpine Wisp Bank (Mid-Screen: ~48% of screen)
    // Organic, delicate cloud mass drifting across the mountain body.
    // =========================================================================
    _paintNoiseRibbon(
      canvas: canvas,
      screenSize: size,
      baseYRatio: 0.48,
      nominalHeight: h * 0.24,
      topAmplitude: h * 0.08,
      bottomAmplitude: h * 0.07,
      topSeed: 38.4,
      bottomSeed: 47.9,
      intervalIn: const Interval(0.10, 0.44, curve: Curves.easeOutCubic),
      intervalOut: const Interval(0.58, 0.88, curve: Curves.easeInCubic),
      sweepInterval: const Interval(0.08, 0.86, curve: Curves.easeInOutCubic),
      speedFactor: 1.02,
      opacityFactor: 0.65,
      primaryColor: Colors.white,
      tintColor: const Color(0xFFF1F5F9),
    );

    // =========================================================================
    // RIBBON 3: Lower Slope Fog (Lower Elevation: ~76% of screen)
    // Soft, airy valley fog drifting gently along the lower slopes.
    // =========================================================================
    _paintNoiseRibbon(
      canvas: canvas,
      screenSize: size,
      baseYRatio: 0.76,
      nominalHeight: h * 0.20,
      topAmplitude: h * 0.07,
      bottomAmplitude: h * 0.06,
      topSeed: 72.1,
      bottomSeed: 85.3,
      intervalIn: const Interval(0.16, 0.52, curve: Curves.easeOutCubic),
      intervalOut: const Interval(0.64, 0.94, curve: Curves.easeInCubic),
      sweepInterval: const Interval(0.14, 0.92, curve: Curves.easeInOutCubic),
      speedFactor: 1.08,
      opacityFactor: 0.52,
      primaryColor: const Color(0xFFF8FAFC),
      tintColor: const Color(0xFFEDE9FE),
    );
  }

  /// Evaluates and renders an organic, soft-edged cloud ribbon across the screen.
  void _paintNoiseRibbon({
    required Canvas canvas,
    required Size screenSize,
    required double baseYRatio,
    required double nominalHeight,
    required double topAmplitude,
    required double bottomAmplitude,
    required double topSeed,
    required double bottomSeed,
    required Interval intervalIn,
    required Interval intervalOut,
    required Interval sweepInterval,
    required double speedFactor,
    required double opacityFactor,
    required Color primaryColor,
    required Color tintColor,
  }) {
    final double w = screenSize.width;
    final double h = screenSize.height;

    final double p = progress.clamp(0.0, 1.0);
    final double opIn = intervalIn.transform(p);
    final double opOut = 1.0 - intervalOut.transform(p);
    final double opacity = (opIn * opOut * opacityFactor).clamp(0.0, 1.0);

    if (opacity <= 0.005) {
      return;
    }

    // Sweep horizontal position from off-screen left to off-screen right
    final double sweep = sweepInterval.transform(p);
    final double ribbonWidth = w * 1.75;
    final double startX = -ribbonWidth * 0.85 + (w + ribbonWidth * 0.85) * sweep * speedFactor;

    final double baseY = h * baseYRatio;

    // Build the organic top and bottom contour using deterministic noise
    final path = Path();
    const double step = 20.0;
    final int stepCount = (ribbonWidth / step).ceil();

    final List<Offset> topPoints = [];
    final List<Offset> bottomPoints = [];

    for (int i = 0; i <= stepCount; i++) {
      final double x = startX + (i * step);
      // Normalized distance along ribbon [0.0, 1.0] to taper the ends
      final double normX = (i / stepCount).clamp(0.0, 1.0);
      // Smooth parabolic envelope so the ribbon tapers to zero thickness at edges
      final double envelope = 4.0 * normX * (1.0 - normX);
      final double taper = math.sqrt(envelope);

      final double topDisp = topAmplitude * _noise(x, topSeed) * taper;
      final double bottomDisp = bottomAmplitude * _noise(x, bottomSeed) * taper;

      final double currentHalfH = (nominalHeight * 0.5) * taper;
      final double yTop = baseY - currentHalfH + topDisp;
      final double yBottom = baseY + currentHalfH + bottomDisp;

      topPoints.add(Offset(x, yTop));
      bottomPoints.add(Offset(x, yBottom));
    }

    if (topPoints.isEmpty) return;

    // Construct closed path: left-to-right along top, then right-to-left along bottom
    path.moveTo(topPoints.first.dx, topPoints.first.dy);

    for (int i = 0; i < topPoints.length - 1; i++) {
      final p0 = topPoints[i];
      final p1 = topPoints[i + 1];
      final mid = Offset((p0.dx + p1.dx) * 0.5, (p0.dy + p1.dy) * 0.5);
      path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    path.lineTo(topPoints.last.dx, topPoints.last.dy);

    // Connect to bottom right
    path.lineTo(bottomPoints.last.dx, bottomPoints.last.dy);

    // Traverse bottom contour in reverse (right-to-left)
    for (int i = bottomPoints.length - 1; i > 0; i--) {
      final p0 = bottomPoints[i];
      final p1 = bottomPoints[i - 1];
      final mid = Offset((p0.dx + p1.dx) * 0.5, (p0.dy + p1.dy) * 0.5);
      path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    path.lineTo(bottomPoints.first.dx, bottomPoints.first.dy);
    path.close();

    // Shading: horizontal feathered gradient with soft edge falloff
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0x00FFFFFF),
          tintColor.withValues(alpha: opacity * 0.20),
          primaryColor.withValues(alpha: opacity * 0.70),
          primaryColor.withValues(alpha: opacity * 0.70),
          tintColor.withValues(alpha: opacity * 0.20),
          const Color(0x00FFFFFF),
        ],
        stops: const [0.0, 0.18, 0.42, 0.58, 0.82, 1.0],
      ).createShader(Rect.fromLTWH(startX, baseY - nominalHeight, ribbonWidth, nominalHeight * 2));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CloudstormPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Route-driven overlay displaying the moving cloud layers across the viewport.
///
/// Ensures zero input interception when dismissed or fully cleared.
class CloudstormOverlay extends StatelessWidget {
  final Animation<double> animation;

  const CloudstormOverlay({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final double progress = animation.value.clamp(0.0, 1.0);

        // Completely disable hit testing and rendering when transitions are settled
        if (progress <= 0.0 || progress >= 1.0) {
          return const SizedBox.shrink();
        }

        return IgnorePointer(
          ignoring: true,
          child: CustomPaint(
            painter: CloudstormPainter(progress: progress),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

/// Custom [PageRouteBuilder] providing the coordinated Cloudstorm Reveal transition.
///
/// Features:
/// - Forward transition duration: 1,300 ms.
/// - Reverse transition duration: 1,000 ms.
/// - Non-opaque route (`opaque: false`) allowing the old Explore screen to be
///   obscured by the moving cloud bank before the Details screen emerges beneath.
/// - Integrated [CloudstormOverlay] rendered atop both scenes during transitions.
/// - Provides [CloudstormScope] for destination child widgets to synchronize their reveals.
class CloudstormPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  CloudstormPageRoute({
    required this.page,
    super.settings,
    Duration? transitionDurationOverride,
    Duration? reverseTransitionDurationOverride,
  }) : super(
          opaque: false,
          maintainState: true,
          transitionDuration: transitionDurationOverride ??
              const Duration(milliseconds: 1300),
          reverseTransitionDuration: reverseTransitionDurationOverride ??
              const Duration(milliseconds: 1000),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return CloudstormScope(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  IgnorePointer(
                    ignoring: true,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: SizedBox.expand(
                          child: ClipRect(
                            child: CloudstormOverlay(animation: animation),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
}
