import 'package:flutter/material.dart';

/// Sequential Horizontal Slide-and-Fade Transition Widget.
///
/// Implements a strict two-phase sequential transition where the outgoing
/// screen exits completely before the incoming screen enters, eliminating
/// any simultaneous overlapping text, cards, or cross-fade artifacts.
///
/// - Forward transition (Explore -> Details, 450 ms):
///   - Phase A (t: 0.0 -> 0.45): Outgoing route (Explore) moves horizontally
///     to the left (Offset.zero -> Offset(-0.12, 0.0)) and fades out (1.0 -> 0.0).
///   - Handoff buffer (t: 0.45 -> 0.50): Both screens have 0.0 opacity against
///     the seamless matching background (Color(0xFFF6F5FC)).
///   - Phase B (t: 0.50 -> 1.0): Incoming route (Details) slides in from the
///     right (Offset(0.12, 0.0) -> Offset.zero) and fades in (0.0 -> 1.0).
///
/// - Reverse transition (Details -> Explore, 400 ms):
///   - Phase A (t: 1.0 -> 0.50): Exiting route (Details) slides to the right
///     (Offset.zero -> Offset(0.12, 0.0)) and fades out (1.0 -> 0.0).
///   - Seamless boundary at t = 0.50: Details finishes fading out and Explore
///     immediately begins entering with zero blank pause or frozen frame.
///   - Phase B (t: 0.50 -> 0.0): Returning route (Explore) slides in from the
///     left (Offset(-0.12, 0.0) -> Offset.zero) and fades in (0.0 -> 1.0).
class SharedAxisTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double>? secondaryAnimation;
  final Widget child;

  const SharedAxisTransition({
    super.key,
    required this.animation,
    this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Primary animation: transforms this route when entering or exiting as top route
    final primaryCurve = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.50, 1.0, curve: Curves.easeOutCubic),
      reverseCurve: const Interval(0.50, 1.0, curve: Curves.easeOutCubic),
    );

    final inSlide = Tween<Offset>(
      begin: const Offset(0.12, 0.0),
      end: Offset.zero,
    ).animate(primaryCurve);

    final inFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(primaryCurve);

    Widget transformed = SlideTransition(
      position: inSlide,
      child: FadeTransition(
        opacity: inFade,
        child: child,
      ),
    );

    // 2. Secondary animation: transforms this route if another route is pushed on top
    final secAnim = secondaryAnimation;
    if (secAnim != null) {
      final secCurve = CurvedAnimation(
        parent: secAnim,
        curve: const Interval(0.0, 0.45, curve: Curves.easeInCubic),
        reverseCurve: const Interval(0.0, 0.50, curve: Curves.easeInCubic),
      );

      final outSlide = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.12, 0.0),
      ).animate(secCurve);

      final outFade = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(secCurve);

      transformed = SlideTransition(
        position: outSlide,
        child: FadeTransition(
          opacity: outFade,
          child: transformed,
        ),
      );
    }

    return transformed;
  }
}

/// Custom [PageRoute] providing sequential horizontal slide-and-fade motion.
///
/// Uses [MaterialRouteTransitionMixin] so Flutter's [ModalRoute] can drive
/// secondary animations on the predecessor route seamlessly.
///
/// Forward duration: 450 ms.
/// Reverse duration: 400 ms.
/// Easing curves: [Curves.easeInCubic] on exit, [Curves.easeOutCubic] on entrance.
class SharedAxisPageRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  final Widget page;

  SharedAxisPageRoute({
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
    return SharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

/// Helper wrapper that coordinates the outgoing route (such as Screen A) to
/// exit sequentially when a new route is pushed on top of it.
class SharedAxisPageWrapper extends StatelessWidget {
  final Widget child;

  const SharedAxisPageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final secondaryAnim = ModalRoute.of(context)?.secondaryAnimation;
    if (secondaryAnim == null) return child;

    final secCurve = CurvedAnimation(
      parent: secondaryAnim,
      curve: const Interval(0.0, 0.45, curve: Curves.easeInCubic),
      reverseCurve: const Interval(0.0, 0.50, curve: Curves.easeInCubic),
    );

    final slide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.12, 0.0),
    ).animate(secCurve);

    final fade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(secCurve);

    return SlideTransition(
      position: slide,
      child: FadeTransition(
        opacity: fade,
        child: child,
      ),
    );
  }
}
