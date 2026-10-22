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

/// A high-performance, GPU-accelerated painter that renders realistic,
/// multi-layered Himalayan mountain clouds and mist sweeping across the viewport.
///
/// Features authentic atmospheric cloud formations:
/// - **Layer 1: Atmospheric Background Haze** — Full-viewport cool white/slate mist blanket
///   that guarantees seamless edge-to-edge coverage during peak obscuration (45%–62%).
/// - **Layer 2: Valley Cloud Bank** — Dense, billowy cumulus formations with organic
///   overlapping puffs that sweep horizontally across the mid-viewport.
/// - **Layer 3: Upper Mountain Cirrus & Mist Ribbons** — Wispy, fast-moving high-altitude
///   cloud tendrils drifting across the upper peaks.
/// - **Layer 4: Lower Valley Fog** — Drifting low-altitude fog layers that blanket
///   the lower cards and terrain.
///
/// All layers use soft whites (`#FFFFFF`), pale snow mist (`#F8FAFC`), and cool
/// slate-blue cloud tones (`#E2E8F0`, `#EDE9FE`) with feathered gradient edges.
/// Completely free of dark radial artifacts, harsh oval masks, or expensive screen blurs.
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
    // LAYER 1: Full-Viewport Atmospheric Background Mist Blanket
    // Provides seamless edge-to-edge coverage during peak obscuration (45%–62%).
    // Cool alpine white (#FFFFFF) and pale slate (#F8FAFC).
    // =========================================================================
    final double blanketIn = const Interval(0.20, 0.48, curve: Curves.easeOutCubic)
        .transform(progress.clamp(0.0, 1.0));
    final double blanketOut = 1.0 -
        const Interval(0.60, 0.88, curve: Curves.easeInCubic)
            .transform(progress.clamp(0.0, 1.0));
    final double blanketOpacity = (blanketIn * blanketOut).clamp(0.0, 1.0);

    if (blanketOpacity > 0.005) {
      // Horizontal drift from left to right
      final double blanketSweep = const Interval(0.10, 0.90, curve: Curves.easeInOutCubic)
          .transform(progress.clamp(0.0, 1.0));
      final double blanketX = -w * 0.4 + (w * 0.8 * blanketSweep);

      final blanketPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0x00FFFFFF),
            const Color(0xFFF8FAFC).withValues(alpha: blanketOpacity * 0.85),
            Colors.white.withValues(alpha: blanketOpacity * 0.98),
            const Color(0xFFF1F5F9).withValues(alpha: blanketOpacity * 0.92),
            const Color(0xFFEDE9FE).withValues(alpha: blanketOpacity * 0.70),
            const Color(0x00FFFFFF),
          ],
          stops: const [0.0, 0.15, 0.45, 0.70, 0.88, 1.0],
        ).createShader(Rect.fromLTWH(blanketX, 0, w * 1.8, h));

      canvas.drawRect(Rect.fromLTWH(0, 0, w, h), blanketPaint);
    }

    // =========================================================================
    // LAYER 2: Main Valley Cloud Bank (Cumulus & Mountain Mist)
    // Moves across the screen during 10%–85%, reaching peak density at 45%–62%.
    // =========================================================================
    final double mainIn = const Interval(0.10, 0.45, curve: Curves.easeOutCubic)
        .transform(progress.clamp(0.0, 1.0));
    final double mainOut = 1.0 -
        const Interval(0.60, 0.92, curve: Curves.easeInCubic)
            .transform(progress.clamp(0.0, 1.0));
    final double mainOpacity = (mainIn * mainOut).clamp(0.0, 1.0);

    if (mainOpacity > 0.005) {
      // Sweep across from left off-screen to right off-screen
      final double mainSweep = const Interval(0.10, 0.88, curve: Curves.easeInOutCubic)
          .transform(progress.clamp(0.0, 1.0));
      final double mainCenterX = -w * 0.8 + (w * 2.2 * mainSweep);

      _paintOrganicCloudFormation(
        canvas: canvas,
        center: Offset(mainCenterX, h * 0.44),
        scaleX: w * 0.0032,
        scaleY: h * 0.0022,
        opacity: mainOpacity,
        baseColor: const Color(0xFFFFFFFF),
        tintColor: const Color(0xFFF1F5F9),
      );
    }

    // =========================================================================
    // LAYER 3: Upper Mountain Cirrus & Drifting Mist Tendrils
    // Fast-moving, wispy high-altitude mist across upper peaks (0%–75%).
    // =========================================================================
    final double upperIn = const Interval(0.00, 0.35, curve: Curves.easeOutCubic)
        .transform(progress.clamp(0.0, 1.0));
    final double upperOut = 1.0 -
        const Interval(0.55, 0.82, curve: Curves.easeInCubic)
            .transform(progress.clamp(0.0, 1.0));
    final double upperOpacity = (upperIn * upperOut * 0.88).clamp(0.0, 1.0);

    if (upperOpacity > 0.005) {
      final double upperSweep = const Interval(0.05, 0.80, curve: Curves.easeInOutCubic)
          .transform(progress.clamp(0.0, 1.0));
      final double upperCenterX = -w * 0.9 + (w * 2.3 * upperSweep);

      _paintWispyMistRibbon(
        canvas: canvas,
        startX: upperCenterX - w * 0.6,
        endX: upperCenterX + w * 0.8,
        centerY: h * 0.22,
        height: h * 0.35,
        opacity: upperOpacity,
        color: const Color(0xFFFFFFFF),
      );
    }

    // =========================================================================
    // LAYER 4: Low Valley Fog & Stratus Layer
    // Heavy, cool low-altitude fog sweeping across the lower half (20%–95%).
    // =========================================================================
    final double lowerIn = const Interval(0.20, 0.50, curve: Curves.easeOutCubic)
        .transform(progress.clamp(0.0, 1.0));
    final double lowerOut = 1.0 -
        const Interval(0.65, 0.96, curve: Curves.easeInCubic)
            .transform(progress.clamp(0.0, 1.0));
    final double lowerOpacity = (lowerIn * lowerOut * 0.94).clamp(0.0, 1.0);

    if (lowerOpacity > 0.005) {
      final double lowerSweep = const Interval(0.18, 0.94, curve: Curves.easeInOutCubic)
          .transform(progress.clamp(0.0, 1.0));
      final double lowerCenterX = -w * 0.85 + (w * 2.3 * lowerSweep);

      _paintWispyMistRibbon(
        canvas: canvas,
        startX: lowerCenterX - w * 0.7,
        endX: lowerCenterX + w * 0.9,
        centerY: h * 0.75,
        height: h * 0.40,
        opacity: lowerOpacity,
        color: const Color(0xFFF8FAFC),
      );

      _paintOrganicCloudFormation(
        canvas: canvas,
        center: Offset(lowerCenterX + w * 0.15, h * 0.72),
        scaleX: w * 0.0028,
        scaleY: h * 0.0018,
        opacity: lowerOpacity * 0.90,
        baseColor: const Color(0xFFF8FAFC),
        tintColor: const Color(0xFFEDE9FE),
      );
    }
  }

  /// Paints a natural, billowy cloud formation composed of varied, soft-edged
  /// overlapping cloud puffs with feathered radial gradients.
  void _paintOrganicCloudFormation({
    required Canvas canvas,
    required Offset center,
    required double scaleX,
    required double scaleY,
    required double opacity,
    required Color baseColor,
    required Color tintColor,
  }) {
    // Relative coordinates (dx, dy, radius) for an organic Himalayan cloud mass
    const List<List<double>> puffs = [
      // Core mass
      [0.0, 0.0, 140.0],
      [-55.0, -25.0, 115.0],
      [65.0, -18.0, 125.0],
      [-110.0, 10.0, 100.0],
      [120.0, 15.0, 110.0],
      // Upper billowy peaks
      [-30.0, -75.0, 95.0],
      [40.0, -85.0, 105.0],
      [95.0, -60.0, 85.0],
      [-80.0, -65.0, 80.0],
      // Flanking wisps
      [-165.0, -15.0, 85.0],
      [-195.0, 20.0, 75.0],
      [175.0, -10.0, 90.0],
      [210.0, 25.0, 75.0],
      // Lower valley spread
      [-60.0, 60.0, 120.0],
      [50.0, 65.0, 130.0],
      [0.0, 80.0, 135.0],
      [-125.0, 70.0, 95.0],
      [135.0, 75.0, 100.0],
    ];

    for (final puff in puffs) {
      final double puffX = center.dx + (puff[0] * scaleX);
      final double puffY = center.dy + (puff[1] * scaleY);
      final double radius = puff[2] * ((scaleX + scaleY) * 0.5);

      final puffCenter = Offset(puffX, puffY);

      final paint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.0, -0.15),
          radius: 0.90,
          colors: [
            baseColor.withValues(alpha: opacity),
            tintColor.withValues(alpha: opacity * 0.75),
            tintColor.withValues(alpha: opacity * 0.35),
            const Color(0x00FFFFFF),
          ],
          stops: const [0.0, 0.45, 0.75, 1.0],
        ).createShader(Rect.fromCircle(center: puffCenter, radius: radius));

      canvas.drawCircle(puffCenter, radius, paint);
    }
  }

  /// Paints a soft, horizontal feathered mist ribbon that stretches across the viewport.
  void _paintWispyMistRibbon({
    required Canvas canvas,
    required double startX,
    required double endX,
    required double centerY,
    required double height,
    required double opacity,
    required Color color,
  }) {
    final double width = (endX - startX).abs();
    if (width <= 0) return;

    final rect = Rect.fromCenter(
      center: Offset((startX + endX) / 2, centerY),
      width: width,
      height: height,
    );

    // Soft horizontal mist band with feathered edges on all 4 sides
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0x00FFFFFF),
          color.withValues(alpha: opacity * 0.40),
          color.withValues(alpha: opacity * 0.85),
          color.withValues(alpha: opacity * 0.85),
          color.withValues(alpha: opacity * 0.40),
          const Color(0x00FFFFFF),
        ],
        stops: const [0.0, 0.18, 0.40, 0.60, 0.82, 1.0],
      ).createShader(rect);

    final path = Path();
    path.moveTo(startX, centerY);
    path.cubicTo(
      startX + width * 0.25,
      centerY - height * 0.5,
      startX + width * 0.75,
      centerY - height * 0.4,
      endX,
      centerY,
    );
    path.cubicTo(
      startX + width * 0.75,
      centerY + height * 0.5,
      startX + width * 0.25,
      centerY + height * 0.4,
      startX,
      centerY,
    );
    path.close();

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
                  CloudstormOverlay(animation: animation),
                ],
              ),
            );
          },
        );
}
