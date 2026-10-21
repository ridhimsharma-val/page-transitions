import 'package:flutter/material.dart';

/// Coordinated Zoom & Fade Transition Widget for Design 03.
///
/// Implements an elegant, premium zoom-and-fade route transition:
///
/// - Forward transition (Explore -> Details, 450 ms):
///   - Outgoing route (Explore): gently recedes from scale 1.00 -> 0.98 and
///     fades out (1.0 -> 0.0) on Interval(0.0, 0.40).
///   - Incoming route (Details): subtle 8% delay before zoom begins on
///     Interval(0.08, 1.0, curve: Curves.easeInOutCubic), smoothly zooming
///     from scale 0.92 -> 1.00 and fading in (0.0 -> 1.0) on Interval(0.30, 0.90).
///   - A subtle, soft hand-off between 0.30 and 0.40 ensures no sudden blank pause
///     while preventing two readable interfaces from competing.
///
/// - Reverse transition (Details -> Explore, 400 ms):
///   - Exiting route (Details): scales down 1.00 -> 0.92 and fades out (1.0 -> 0.0)
///     on Interval(0.45, 0.95).
///   - Returning route (Explore): scales back up 0.98 -> 1.00 and fades in (0.0 -> 1.0)
///     on Interval(0.10, 0.55).
///   - Seamless hand-off with natural momentum and zero visible pause.
class ZoomFadeTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double>? secondaryAnimation;
  final Widget child;

  const ZoomFadeTransition({
    super.key,
    required this.animation,
    this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (disableAnimations) {
      return child;
    }

    // 1. Primary animation: transforms this route when entering or exiting as top route
    final primaryScaleCurve = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.08, 1.0, curve: Curves.easeInOutCubic),
      reverseCurve: const Interval(0.08, 1.0, curve: Curves.easeInOutCubic),
    );

    final primaryFadeCurve = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.30, 0.90, curve: Curves.easeOutCubic),
      reverseCurve: const Interval(0.45, 0.95, curve: Curves.easeOutCubic),
    );

    final inScale = Tween<double>(
      begin: 0.92,
      end: 1.00,
    ).animate(primaryScaleCurve);

    final inFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(primaryFadeCurve);

    Widget transformed = ScaleTransition(
      scale: inScale,
      child: FadeTransition(
        opacity: inFade,
        child: child,
      ),
    );

    // 2. Secondary animation: transforms this route when another route is pushed on top
    final secAnim = secondaryAnimation;
    if (secAnim != null) {
      final secScaleCurve = CurvedAnimation(
        parent: secAnim,
        curve: Curves.easeInOutCubic,
        reverseCurve: Curves.easeInOutCubic,
      );

      final secFadeCurve = CurvedAnimation(
        parent: secAnim,
        curve: const Interval(0.0, 0.40, curve: Curves.easeInCubic),
        reverseCurve: const Interval(0.10, 0.55, curve: Curves.easeInCubic),
      );

      final outScale = Tween<double>(
        begin: 1.00,
        end: 0.98,
      ).animate(secScaleCurve);

      final outFade = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(secFadeCurve);

      transformed = ScaleTransition(
        scale: outScale,
        child: FadeTransition(
          opacity: outFade,
          child: transformed,
        ),
      );
    }

    return transformed;
  }
}

/// Custom [PageRoute] providing coordinated zoom & fade motion.
///
/// Uses [MaterialRouteTransitionMixin] so Flutter's [ModalRoute] can drive
/// secondary animations on the predecessor route seamlessly.
///
/// Forward duration: 450 ms.
/// Reverse duration: 400 ms.
/// Primary curve: [Curves.easeInOutCubic].
class ZoomFadePageRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  final Widget page;

  ZoomFadePageRoute({
    required this.page,
    super.settings,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
  });

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 450);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 400);

  @override
  Widget buildContent(BuildContext context) => page;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ZoomFadeTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

/// Helper wrapper that coordinates the outgoing route (such as Screen A) to
/// gently zoom out and fade when a new route is pushed on top of it.
class ZoomFadePageWrapper extends StatelessWidget {
  final Widget child;

  const ZoomFadePageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableAnimations) return child;

    final secondaryAnim = ModalRoute.of(context)?.secondaryAnimation;
    if (secondaryAnim == null) return child;

    final secScaleCurve = CurvedAnimation(
      parent: secondaryAnim,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );

    final secFadeCurve = CurvedAnimation(
      parent: secondaryAnim,
      curve: const Interval(0.0, 0.40, curve: Curves.easeInCubic),
      reverseCurve: const Interval(0.10, 0.55, curve: Curves.easeInCubic),
    );

    final scale = Tween<double>(
      begin: 1.00,
      end: 0.98,
    ).animate(secScaleCurve);

    final fade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(secFadeCurve);

    return ScaleTransition(
      scale: scale,
      child: FadeTransition(
        opacity: fade,
        child: child,
      ),
    );
  }
}
