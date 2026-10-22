import 'package:flutter/material.dart';
import '../screens/mountain_page.dart';
import '../screens/shared_axis_demo/shared_axis_explore_screen.dart';
import '../screens/zoom_fade_demo/zoom_fade_explore_screen.dart';
import '../screens/parallax_demo/parallax_explore_screen.dart';
import '../screens/circular_carousel_demo/circular_carousel_explore_screen.dart';
import '../screens/cloudstorm_demo/cloudstorm_explore_screen.dart';

/// Registry entry defining a self-contained UI design in the Page Transitions Lab gallery.
class DesignEntry {
  final String id;
  final String designNumber;
  final String title;
  final Widget Function(BuildContext context) builder;

  const DesignEntry({
    required this.id,
    required this.designNumber,
    required this.title,
    required this.builder,
  });
}

class DesignRegistry {
  static final List<DesignEntry> entries = [
    // Design 01 — Hero Transition
    DesignEntry(
      id: 'mountain-world',
      designNumber: 'Design 01',
      title: 'Hero Transition',
      builder: (context) => const MountainPage(),
    ),

    // Design 02 — Shared-Axis Transition
    DesignEntry(
      id: 'shared-axis-transition',
      designNumber: 'Design 02',
      title: 'Shared-Axis Transition',
      builder: (context) => const SharedAxisExploreScreen(),
    ),

    // Design 03 — Zoom & Fade Transition
    DesignEntry(
      id: 'zoom-fade-transition',
      designNumber: 'Design 03',
      title: 'Zoom & Fade Transition',
      builder: (context) => const ZoomFadeExploreScreen(),
    ),

    // Design 04 — Parallax Depth
    DesignEntry(
      id: 'parallax-depth-transition',
      designNumber: 'Design 04',
      title: 'Parallax Depth',
      builder: (context) => const ParallaxExploreScreen(),
    ),

    // Design 05 — Circular Carousel + Circular Reveal
    DesignEntry(
      id: 'circular-carousel-reveal',
      designNumber: 'Design 05',
      title: 'Circular Carousel',
      builder: (context) => const CircularCarouselExploreScreen(),
    ),

    // Design 06 — Cloudstorm Reveal
    DesignEntry(
      id: 'cloudstorm-reveal',
      designNumber: 'Design 06',
      title: 'Cloudstorm Reveal',
      builder: (context) => const CloudstormExploreScreen(),
    ),
  ];
}
