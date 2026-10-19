import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Damped harmonic spring curve for natural weight and responsiveness
class DampedSpringCurve extends Curve {
  final double damping;
  final double stiffness;

  const DampedSpringCurve({
    this.damping = 16.0,
    this.stiffness = 180.0,
  });

  @override
  double transformInternal(double t) {
    if (t >= 1.0) return 1.0;
    if (t <= 0.0) return 0.0;

    // Damped harmonic oscillation equation: 1 - e^(-gamma * t) * (cos(omega * t) + (gamma/omega) * sin(omega * t))
    final gamma = damping / 2.0;
    final omegaSquared = stiffness - (gamma * gamma);
    final omega = omegaSquared > 0 ? math.sqrt(omegaSquared) : 1.0;

    final envelope = math.exp(-gamma * t * 3.5);
    final oscillation = math.cos(omega * t * 3.5) + (gamma / omega) * math.sin(omega * t * 3.5);

    final value = 1.0 - (envelope * oscillation);
    return value.clamp(0.0, 1.08); // Tiny controlled overshoot for snap feel
  }
}

/// Custom PageRouteBuilder combining spring slide, subtle depth scale, and opacity
class SpringSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final AxisDirection direction;

  SpringSlidePageRoute({
    required this.page,
    this.direction = AxisDirection.left,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 650),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Forward spring curve
            final springCurved = CurvedAnimation(
              parent: animation,
              curve: const DampedSpringCurve(),
              reverseCurve: Curves.easeInOutCubic,
            );

            // Compute offset translation based on direction
            Offset beginOffset;
            switch (direction) {
              case AxisDirection.left:
                beginOffset = const Offset(1.0, 0.0);
                break;
              case AxisDirection.right:
                beginOffset = const Offset(-1.0, 0.0);
                break;
              case AxisDirection.up:
                beginOffset = const Offset(0.0, 1.0);
                break;
              case AxisDirection.down:
                beginOffset = const Offset(0.0, -1.0);
                break;
            }

            final slideAnimation = Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(springCurved);

            // Subtle scale-up from 0.94 to 1.0 gives physical depth
            final scaleAnimation = Tween<double>(
              begin: 0.94,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );

            // Opacity fade in
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                reverseCurve: const Interval(0.4, 1.0, curve: Curves.easeIn),
              ),
            );

            // Secondary animation for when another screen pushes on top of this one
            final secondarySlide = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.25, 0.0),
            ).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeInOutCubic,
              ),
            );

            final secondaryScale = Tween<double>(
              begin: 1.0,
              end: 0.92,
            ).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeInOutCubic,
              ),
            );

            return SlideTransition(
              position: secondarySlide,
              child: ScaleTransition(
                scale: secondaryScale,
                child: SlideTransition(
                  position: slideAnimation,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: FadeTransition(
                      opacity: fadeAnimation,
                      child: child,
                    ),
                  ),
                ),
              ),
            );
          },
        );
}
