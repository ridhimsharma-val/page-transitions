import 'package:flutter/material.dart';
import '../models/mountain_data.dart';
import '../widgets/mountain_image_widget.dart';

/// Rect tween that applies a custom curve (default [Curves.easeInOutCubic])
/// across physical Hero movement.
class CurvedRectTween extends RectTween {
  final Curve curve;

  CurvedRectTween({
    super.begin,
    super.end,
    this.curve = Curves.easeInOutCubic,
  });

  @override
  Rect? lerp(double t) {
    if (begin == null || end == null) return null;
    final double curvedT = curve.transform(t.clamp(0.0, 1.0));
    return Rect.lerp(begin, end, curvedT);
  }
}

/// Scope providing the route animation to descendants in Design 06.
class SharedElementMorphScope extends InheritedWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  const SharedElementMorphScope({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required super.child,
  });

  static SharedElementMorphScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SharedElementMorphScope>();
  }

  @override
  bool updateShouldNotify(SharedElementMorphScope oldWidget) {
    return animation != oldWidget.animation ||
        secondaryAnimation != oldWidget.secondaryAnimation;
  }
}

/// Standardized flight shuttle builder for Design 06.
///
/// Interpolates the corner radius smoothly between the source card
/// (`BorderRadius.circular(24)`) and the destination image
/// (`BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32))`)
/// strictly across the normalized interval [0.00, 0.78] with [Curves.easeInOutCubic].
Widget buildSharedElementFlightShuttle({
  required BuildContext flightContext,
  required Animation<double> animation,
  required HeroFlightDirection flightDirection,
  required BuildContext fromHeroContext,
  required BuildContext toHeroContext,
  required MountainData mountain,
  BorderRadius sourceRadius = const BorderRadius.all(Radius.circular(24.0)),
  BorderRadius destinationRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(32.0),
    bottomRight: Radius.circular(32.0),
  ),
}) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, _) {
      final double progress = animation.value.clamp(0.0, 1.0);
      // Timeline Requirement: Corner radius morphs 0% to 78% with Curves.easeInOutCubic
      final double cornerProgress = const Interval(
        0.00,
        0.78,
        curve: Curves.easeInOutCubic,
      ).transform(progress);

      final BorderRadius currentRadius = BorderRadius.lerp(
        sourceRadius,
        destinationRadius,
        cornerProgress,
      )!;

      return ClipRRect(
        borderRadius: currentRadius,
        child: MountainImageWidget(
          imageUrl: mountain.imageUrl,
          mountainName: mountain.name,
          fit: BoxFit.cover,
        ),
      );
    },
  );
}

/// Custom [PageRouteBuilder] providing coordinated Shared Element Morph motion.
///
/// Features:
/// - Forward transition duration: 900 ms.
/// - Reverse transition duration: 750 ms.
/// - Non-opaque route (`opaque: false`) allowing the underlying Explore screen
///   to remain visible while the destination background fades in from 20% to 72%
///   and the Hero image travels overhead in the Overlay.
/// - Provides [SharedElementMorphScope] for child widgets to hook into the exact timeline.
class SharedElementMorphRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SharedElementMorphRoute({
    required this.page,
    super.settings,
    Duration? transitionDurationOverride,
    Duration? reverseTransitionDurationOverride,
  }) : super(
          opaque: false,
          maintainState: true,
          transitionDuration: transitionDurationOverride ??
              const Duration(milliseconds: 900),
          reverseTransitionDuration: reverseTransitionDurationOverride ??
              const Duration(milliseconds: 750),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedElementMorphScope(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        );
}
