import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/mountain_data.dart';
import 'mountain_image_widget.dart';

/// Standard linear Rect lerp driven smoothly by Flutter's HeroController curve.
class SmoothHeroRectTween extends RectTween {
  SmoothHeroRectTween({super.begin, super.end});

  @override
  Rect? lerp(double t) {
    if (begin == null || end == null) return null;
    return Rect.fromLTRB(
      ui.lerpDouble(begin!.left, end!.left, t)!,
      ui.lerpDouble(begin!.top, end!.top, t)!,
      ui.lerpDouble(begin!.right, end!.right, t)!,
      ui.lerpDouble(begin!.bottom, end!.bottom, t)!,
    );
  }
}

/// Ultra-smooth Hero flight shuttle:
/// - Reuses static image instance (zero widget churn, zero re-renders per frame)
/// - Perfectly synchronized corner radius morph in exact lockstep with flight bounds
/// - Hardware-accelerated sub-pixel anti-aliased clipping with zero boundary jumps
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
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    // Build the static image widget ONCE so it is never recreated during flight
    final staticImage = MountainImageWidget(
      imageUrl: mountain.imageUrl,
      mountainName: mountain.name,
      fit: BoxFit.cover,
    );

    return AnimatedBuilder(
      animation: animation,
      child: staticImage,
      builder: (context, child) {
        if (disableAnimations) {
          return ClipRRect(
            borderRadius: destinationRadius,
            child: child,
          );
        }

        final t = animation.value.clamp(0.0, 1.0);
        final currentRadius = BorderRadius.lerp(sourceRadius, destinationRadius, t)!;

        return ClipRRect(
          borderRadius: currentRadius,
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      },
    );
  }
}
