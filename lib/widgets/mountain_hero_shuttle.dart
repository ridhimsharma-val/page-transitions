import 'package:flutter/material.dart';

import '../models/mountain_data.dart';
import 'mountain_image_widget.dart';

/// Interpolates the Hero image's bounds.
///
/// Smooth cubic easing gives the image a natural, buttery acceleration and
/// deceleration across the screen.
class SmoothHeroRectTween extends RectTween {
  SmoothHeroRectTween({super.begin, super.end});

  @override
  Rect? lerp(double t) {
    final start = begin;
    final finish = end;

    if (start == null || finish == null) {
      return null;
    }

    final curvedT = Curves.easeInOutCubicEmphasized.transform(t.clamp(0.0, 1.0));
    return Rect.lerp(start, finish, curvedT);
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
    // Drive the radius animation with the matching emphasized cubic curve
    // so corner rounding stays in precise spatial lockstep with flight bounds.
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );

    final radiusAnimation = BorderRadiusTween(
      begin: sourceRadius,
      end: destinationRadius,
    ).animate(curvedAnimation);

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
