import 'dart:math' as math;
import 'package:flutter/material.dart';

enum FlipAxis {
  horizontal, // Rotates around Y-axis (book/door flip)
  vertical,   // Rotates around X-axis (card flip)
}

/// A perspective 3D flip route that rotates the screen with lighting/depth shading
class Flip3DPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final FlipAxis axis;
  final Duration transitionDurationOverride;

  Flip3DPageRoute({
    required this.page,
    this.axis = FlipAxis.horizontal,
    this.transitionDurationOverride = const Duration(milliseconds: 800),
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: transitionDurationOverride,
          reverseTransitionDuration: Duration(
            milliseconds: (transitionDurationOverride.inMilliseconds * 0.85).round(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubicEmphasized,
              reverseCurve: Curves.easeInOutCubic,
            );

            return AnimatedBuilder(
              animation: curvedAnimation,
              builder: (context, _) {
                final progress = curvedAnimation.value;

                // Incoming screen flips from 90 degrees to 0 degrees
                // As progress goes from 0.0 to 1.0, angle goes from math.pi / 2 to 0
                final angle = (1.0 - progress) * (math.pi / 2);

                // Depth zoom: screen pushes back slightly in 3D space during the flip
                final scale = 0.88 + 0.12 * math.sin(progress * math.pi / 2);

                final matrix = Matrix4.identity()
                  ..setEntry(3, 2, 0.0014); // Perspective projection factor

                if (axis == FlipAxis.horizontal) {
                  matrix.rotateY(-angle);
                } else {
                  matrix.rotateX(angle);
                }

                // Dynamic shadow shading simulating lighting falloff during rotation
                final shadowOpacity = ((1.0 - progress) * 0.75).clamp(0.0, 1.0);

                return Transform(
                  alignment: axis == FlipAxis.horizontal
                      ? Alignment.centerLeft
                      : Alignment.topCenter,
                  transform: matrix,
                  child: Transform.scale(
                    scale: scale,
                    child: Stack(
                      children: [
                        child,
                        // Glancing light shadow
                        if (shadowOpacity > 0.01)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Container(
                                color: Colors.black.withOpacity(shadowOpacity),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
}
