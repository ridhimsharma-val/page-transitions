import 'package:flutter/material.dart';

import '../models/mountain_data.dart';
import 'mountain_image_widget.dart';

/// Interpolates the Hero image's bounds.
///
/// Keep this tween linear. Flutter's Hero flight animation already controls
/// the timing curve, so applying another curve here can distort the motion.
class SmoothHeroRectTween extends RectTween {
  SmoothHeroRectTween({super.begin, super.end});

  @override
  Rect? lerp(double t) {
    final start = begin;
    final finish = end;

    if (start == null || finish == null) {
      return null;
    }

    return Rect.lerp(start, finish, t);
  }
}

/// Image displayed inside the native Flutter Hero flight overlay.
///
/// The image stays as the AnimatedBuilder child, so changing the corner
/// radius does not rebuild the image subtree on every animation tick.
class MountainHeroFlightShuttle extends StatelessWidget {
  final Animation<double> animation;
  final HeroFlightDirection flightDirection;
  final MountainData mountain;
  final BorderRadius sourceRadius;
  final BorderRadius destinationRadius;

  const MountainHeroFlightShuttle({
    super.key,
    required this.animation,
    required this.flightDirection,
    required this.mountain,
    this.sourceRadius = const BorderRadius.all(Radius.circular(16)),
    this.destinationRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(28),
      bottomRight: Radius.circular(28),
    ),
  });

  @override
  Widget build(BuildContext context) {
    // Flutter drives this animation forward when opening and backward when
    // returning. Using the same animation preserves reverse interpolation.
    final radiusAnimation = BorderRadiusTween(
      begin: sourceRadius,
      end: destinationRadius,
    ).animate(animation);

    return AnimatedBuilder(
      animation: radiusAnimation,
      child: RepaintBoundary(
        child: MountainImageWidget(
          imageUrl: mountain.imageUrl,
          mountainName: mountain.name,
          fit: BoxFit.cover,
        ),
      ),
      builder: (context, child) {
        return ClipRRect(
          borderRadius: radiusAnimation.value ?? sourceRadius,
          clipBehavior: Clip.antiAlias,
          child: SizedBox.expand(child: child),
        );
      },
    );
  }
}
