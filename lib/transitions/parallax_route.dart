import 'package:flutter/material.dart';

/// Scope that provides route animation to descendants within a Parallax transition.
class ParallaxScope extends InheritedWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  const ParallaxScope({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required super.child,
  });

  static ParallaxScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ParallaxScope>();
  }

  @override
  bool updateShouldNotify(ParallaxScope oldWidget) {
    return animation != oldWidget.animation ||
        secondaryAnimation != oldWidget.secondaryAnimation;
  }
}

/// Custom [PageRouteBuilder] providing coordinated Parallax Depth motion.
///
/// Forward duration: 700 ms.
/// Reverse duration: 550 ms.
///
/// Does not apply a uniform full-screen slide, scale, or fade, allowing individual
/// layers (background, mountain photograph, foreground typography, and info cards)
/// to move independently at differential speeds and vectors.
class ParallaxPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  ParallaxPageRoute({
    required this.page,
    super.settings,
  }) : super(
          transitionDuration: const Duration(milliseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 550),
          maintainState: true,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ParallaxScope(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        );
}

/// Wrapper for Screen A Explore to maintain stability during route transitions.
///
/// Avoids whole-screen fades or jarring jumps, ensuring the Explore screen
/// returns seamlessly to its original state when Details is popped.
class ParallaxPageWrapper extends StatelessWidget {
  final Widget child;

  const ParallaxPageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
