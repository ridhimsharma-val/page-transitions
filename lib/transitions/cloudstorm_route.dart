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

/// A high-performance, GPU-accelerated painter that renders multi-layered
/// volumetric mountain cloud banks sweeping across the viewport.
///
/// Features three distinct depth layers:
/// - **Layer C (Background Haze)**: Soft, low-contrast drifting mist that softens backgrounds.
/// - **Layer B (Midground Clouds)**: Billowy, overlapping cloud silhouettes with organic undulation.
/// - **Layer A (Foreground Mist)**: Dense, feathered atmospheric fog sweeping across the camera,
///   creating peak obscuration between 45% and 62% of the timeline.
class CloudstormPainter extends CustomPainter {
  final double progress;

  CloudstormPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) {
      return;
    }

    final double w = size.width;
    final double h = size.height;

    // =========================================================================
    // Layer C: Background Atmospheric Haze (Drifts slowly, blends scenes)
    // Active: 0.00 -> 0.85
    // =========================================================================
    final double hazeIn = const Interval(0.00, 0.35, curve: Curves.easeOut)
        .transform(progress.clamp(0.0, 1.0));
    final double hazeOut = 1.0 -
        const Interval(0.55, 0.85, curve: Curves.easeIn)
            .transform(progress.clamp(0.0, 1.0));
    final double hazeOpacity = (hazeIn * hazeOut * 0.75).clamp(0.0, 1.0);

    if (hazeOpacity > 0.005) {
      final double hazeShiftX = -w * 0.3 + (w * 0.8 * progress);
      final hazePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0x00F8FAFC),
            Color.fromRGBO(241, 245, 249, hazeOpacity * 0.7),
            Color.fromRGBO(248, 250, 252, hazeOpacity),
            Color.fromRGBO(237, 233, 254, hazeOpacity * 0.6),
            const Color(0x00F8FAFC),
          ],
          stops: const [0.0, 0.25, 0.50, 0.75, 1.0],
        ).createShader(Rect.fromLTWH(hazeShiftX, 0, w * 1.6, h));

      canvas.drawRect(Rect.fromLTWH(0, 0, w, h), hazePaint);
    }

    // =========================================================================
    // Layer B: Midground Clouds (Irregular cloud bank with soft rounded puffs)
    // Active: 0.10 -> 0.88
    // =========================================================================
    final double midIn = const Interval(0.10, 0.40, curve: Curves.easeOutCubic)
        .transform(progress.clamp(0.0, 1.0));
    final double midOut = 1.0 -
        const Interval(0.62, 0.88, curve: Curves.easeInCubic)
            .transform(progress.clamp(0.0, 1.0));
    final double midOpacity = (midIn * midOut * 0.92).clamp(0.0, 1.0);

    if (midOpacity > 0.005) {
      // Horizontal travel from -w*1.1 to +w*1.2
      final double midSweep = const Interval(0.10, 0.85, curve: Curves.easeInOutCubic)
          .transform(progress.clamp(0.0, 1.0));
      final double midCenterX = -w * 1.1 + (w * 2.3 * midSweep);

      _paintCloudBank(
        canvas: canvas,
        center: Offset(midCenterX, h * 0.42),
        width: w * 1.7,
        height: h * 1.25,
        baseColor: const Color(0xFFF1F5F9),
        highlightColor: Colors.white,
        opacity: midOpacity,
        seed: 42,
      );
    }

    // =========================================================================
    // Layer A: Foreground Mist & Peak Obscuration
    // Peak obscuration: 45% -> 62%
    // Active: 0.15 -> 0.98
    // =========================================================================
    final double foreIn = const Interval(0.15, 0.45, curve: Curves.easeOutCubic)
        .transform(progress.clamp(0.0, 1.0));
    final double foreOut = 1.0 -
        const Interval(0.62, 0.98, curve: Curves.easeInCubic)
            .transform(progress.clamp(0.0, 1.0));
    final double foreOpacity = (foreIn * foreOut).clamp(0.0, 1.0);

    if (foreOpacity > 0.005) {
      final double foreSweep = const Interval(0.15, 0.92, curve: Curves.easeInOutCubic)
          .transform(progress.clamp(0.0, 1.0));
      final double foreCenterX = -w * 1.2 + (w * 2.5 * foreSweep);

      _paintCloudBank(
        canvas: canvas,
        center: Offset(foreCenterX, h * 0.52),
        width: w * 2.0,
        height: h * 1.35,
        baseColor: const Color(0xFFFFFFFF),
        highlightColor: const Color(0xFFF8FAFC),
        opacity: foreOpacity,
        seed: 137,
      );

      // Core blanket for total obscuration at peak [0.45, 0.62]
      final double peakDense = const Interval(0.42, 0.52, curve: Curves.easeInOut)
              .transform(progress.clamp(0.0, 1.0)) *
          (1.0 -
              const Interval(0.58, 0.65, curve: Curves.easeInOut)
                  .transform(progress.clamp(0.0, 1.0)));

      if (peakDense > 0.01) {
        final corePaint = Paint()
          ..shader = RadialGradient(
            center: Alignment.center,
            radius: 0.85,
            colors: [
              Color.fromRGBO(255, 255, 255, (peakDense * 0.98).clamp(0.0, 1.0)),
              Color.fromRGBO(248, 250, 252, (peakDense * 0.92).clamp(0.0, 1.0)),
              Color.fromRGBO(241, 245, 249, (peakDense * 0.65).clamp(0.0, 1.0)),
              const Color(0x00FFFFFF),
            ],
            stops: const [0.0, 0.55, 0.80, 1.0],
          ).createShader(Rect.fromCenter(
            center: Offset(foreCenterX, h * 0.50),
            width: w * 1.8,
            height: h * 1.4,
          ));

        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), corePaint);
      }
    }
  }

  /// Renders an organic bank of volumetric, soft-edged cloud puffs.
  void _paintCloudBank({
    required Canvas canvas,
    required Offset center,
    required double width,
    required double height,
    required Color baseColor,
    required Color highlightColor,
    required double opacity,
    required int seed,
  }) {
    // Generate organic puff clusters offset around center
    final List<Offset> puffOffsets = [
      Offset(-width * 0.35, -height * 0.25),
      Offset(-width * 0.15, -height * 0.35),
      Offset(width * 0.08, -height * 0.28),
      Offset(width * 0.32, -height * 0.18),
      Offset(-width * 0.40, 0.0),
      Offset(-width * 0.18, height * 0.05),
      Offset(width * 0.05, -height * 0.02),
      Offset(width * 0.28, height * 0.08),
      Offset(-width * 0.25, height * 0.28),
      Offset(0.0, height * 0.32),
      Offset(width * 0.22, height * 0.25),
    ];

    final List<double> puffRadii = [
      width * 0.38,
      width * 0.45,
      width * 0.42,
      width * 0.36,
      width * 0.42,
      width * 0.52,
      width * 0.55,
      width * 0.44,
      width * 0.40,
      width * 0.48,
      width * 0.38,
    ];

    for (int i = 0; i < puffOffsets.length; i++) {
      final Offset puffCenter = center + puffOffsets[i];
      final double radius = puffRadii[i];

      final puffPaint = Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.95,
          colors: [
            Color.fromRGBO(
              highlightColor.r.round(),
              highlightColor.g.round(),
              highlightColor.b.round(),
              opacity,
            ),
            Color.fromRGBO(
              baseColor.r.round(),
              baseColor.g.round(),
              baseColor.b.round(),
              (opacity * 0.85).clamp(0.0, 1.0),
            ),
            Color.fromRGBO(
              baseColor.r.round(),
              baseColor.g.round(),
              baseColor.b.round(),
              (opacity * 0.45).clamp(0.0, 1.0),
            ),
            Color.fromRGBO(
              baseColor.r.round(),
              baseColor.g.round(),
              baseColor.b.round(),
              0.0,
            ),
          ],
          stops: const [0.0, 0.42, 0.72, 1.0],
        ).createShader(Rect.fromCircle(center: puffCenter, radius: radius));

      canvas.drawCircle(puffCenter, radius, puffPaint);
    }
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
                  CloudstormOverlay(animation: animation),
                ],
              ),
            );
          },
        );
}
