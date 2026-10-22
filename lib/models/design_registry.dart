import 'package:flutter/material.dart';
import '../screens/mountain_page.dart';
import '../screens/circular_carousel_demo/circular_carousel_explore_screen.dart';
import '../screens/shared_element_demo/shared_element_explore_screen.dart';

/// Registry entry defining a self-contained UI design in the Page Transitions Lab gallery.
/// To register a new independent design, simply add a new [DesignEntry] to [DesignRegistry.entries].
class DesignEntry {
  final String id;
  final String title;
  final String category;
  final String description;
  final String? previewImageUrl;
  final IconData icon;
  final Color accentColor;
  final bool isAvailable;
  final Widget Function(BuildContext context)? builder;

  const DesignEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    this.previewImageUrl,
    required this.icon,
    required this.accentColor,
    this.isAvailable = true,
    this.builder,
  });
}

class DesignRegistry {
  static final List<DesignEntry> entries = [
    // 1. World Above 8,000 Metres (Primary Design Showcase)
    DesignEntry(
      id: 'mountain-world',
      title: 'World Above 8,000 Metres',
      category: 'Travel & Exploration',
      description:
          'Explore the world\'s highest peaks through a light, photography-led mountain mobile experience with genuine Hero transitions.',
      previewImageUrl:
          'https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=1200&auto=format&fit=crop',
      icon: Icons.landscape_rounded,
      accentColor: const Color(0xFF7C3AED),
      isAvailable: true,
      builder: (context) => const MountainPage(),
    ),

    // 2. Interactive Motion Experiments (Hosts the 5 transitions)
    const DesignEntry(
      id: 'motion-lab',
      title: 'Interactive Motion Experiments',
      category: 'Motion & Physics',
      description:
          'Five screen-to-screen transitions: Hero flight, circular aperture, spring slide, 3D flip, and liquid wave.',
      icon: Icons.motion_photos_on_rounded,
      accentColor: Color(0xFF0284C7),
      isAvailable: true,
    ),

    // Design 05 — Circular Carousel + Circular Reveal
    DesignEntry(
      id: 'circular-carousel-reveal',
      title: 'Design 05 — Circular Carousel',
      category: 'Design 05 • Motion',
      description:
          'Curved interactive mountain carousel with a smooth expanding circular reveal originating from the active mountain card.',
      icon: Icons.album_rounded,
      accentColor: const Color(0xFF7C3AED),
      isAvailable: true,
      builder: (context) => const CircularCarouselExploreScreen(),
    ),

    // Design 06 — Shared Element Morph
    DesignEntry(
      id: 'shared-element-morph',
      title: 'Design 06 — Shared Element Morph',
      category: 'Design 06 • Motion',
      description:
          'Cinematic shared-element flight with coordinated corner-radius morphing and staggered content arrival.',
      icon: Icons.auto_awesome_motion_rounded,
      accentColor: const Color(0xFF7C3AED),
      isAvailable: true,
      builder: (context) => const SharedElementExploreScreen(),
    ),

    // 3. Architectural Typography Studio (Future concept)
    const DesignEntry(
      id: 'minimal-portfolio',
      title: 'Architectural Typography Studio',
      category: 'Minimal Portfolio',
      description:
          'Monochromatic Swiss grid layouts, fluid editorial typesetting, and frictionless transitions.',
      icon: Icons.architecture_rounded,
      accentColor: Color(0xFF059669),
      isAvailable: false,
    ),

    // 4. Botanical Field Records (Future concept)
    const DesignEntry(
      id: 'nature-journal',
      title: 'Botanical Field Records',
      category: 'Nature Journal',
      description:
          'High-density biological cataloging, smooth card expansions, and tactile botanical illustrations.',
      icon: Icons.eco_rounded,
      accentColor: Color(0xFFD97706),
      isAvailable: false,
    ),
  ];
}
