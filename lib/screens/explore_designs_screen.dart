import 'package:flutter/material.dart';
import '../models/mountain_data.dart';
import '../theme/app_theme.dart';
import '../widgets/mountain_image_widget.dart';
import 'mountain_page.dart';
import 'shared_axis_demo/shared_axis_explore_screen.dart';
import 'zoom_fade_demo/zoom_fade_explore_screen.dart';

// Transition demos accessible through the Motion Experiments gallery card
import 'circular_demo_screen.dart';
import 'spring_demo_screen.dart';
import 'flip_demo_screen.dart';
import 'liquid_demo_screen.dart';
import '../transitions/circular_reveal_route.dart';
import '../transitions/spring_slide_route.dart';
import '../transitions/flip_3d_route.dart';
import '../transitions/liquid_swipe_route.dart';

class DesignConcept {
  final String id;
  final String title;
  final String category;
  final String description;
  final String? previewImageUrl;
  final IconData icon;
  final Color accentColor;
  final bool isAvailable;
  final Widget? destinationPage;

  const DesignConcept({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    this.previewImageUrl,
    required this.icon,
    required this.accentColor,
    this.isAvailable = true,
    this.destinationPage,
  });
}

class ExploreDesignsScreen extends StatefulWidget {
  const ExploreDesignsScreen({super.key});

  @override
  State<ExploreDesignsScreen> createState() => _ExploreDesignsScreenState();
}

class _ExploreDesignsScreenState extends State<ExploreDesignsScreen> {
  bool _isNavigating = false;

  late final List<DesignConcept> _designs;

  @override
  void initState() {
    super.initState();
    _designs = [
      // 1. World Above 8,000 Metres (Primary Design)
      DesignConcept(
        id: 'mountain-world',
        title: 'World Above 8,000 Metres',
        category: 'Travel & Exploration',
        description:
            'Explore the world\'s highest peaks through a light, photography-led mountain mobile experience with genuine Hero transitions.',
        previewImageUrl: MountainData.everest.imageUrl,
        icon: Icons.landscape_rounded,
        accentColor: const Color(0xFF7C3AED),
        isAvailable: true,
        destinationPage: const MountainPage(),
      ),

      // 2. Design 02 — Horizontal Shared-Axis Transition
      const DesignConcept(
        id: 'shared-axis-transition',
        title: 'Shared-Axis Transition',
        category: 'Design 02 • Motion',
        description:
            'Coordinated horizontal movement with synchronized slide, fade, and subtle scaling between routes.',
        icon: Icons.compare_arrows_rounded,
        accentColor: Color(0xFF7C3AED),
        isAvailable: true,
        destinationPage: SharedAxisExploreScreen(),
      ),

      // 3. Design 03 — Zoom & Fade Transition
      const DesignConcept(
        id: 'zoom-fade-transition',
        title: 'Design 03 — Zoom & Fade Transition',
        category: 'Design 03 • Motion',
        description:
            'Gently zooms into normal scale while fading in, with a subtly receding outgoing view.',
        icon: Icons.zoom_in_rounded,
        accentColor: Color(0xFF7C3AED),
        isAvailable: true,
        destinationPage: ZoomFadeExploreScreen(),
      ),

      // 3. Interactive Motion Experiments (Hosts the 5 transition demos)
      const DesignConcept(
        id: 'motion-lab',
        title: 'Interactive Motion Experiments',
        category: 'Motion & Physics',
        description:
            'Five screen-to-screen transitions: Hero flight, circular aperture, spring slide, 3D flip, and liquid wave.',
        icon: Icons.motion_photos_on_rounded,
        accentColor: Color(0xFF0284C7),
        isAvailable: true,
      ),

      // 3. Minimal Portfolio (Future Concept)
      const DesignConcept(
        id: 'minimal-portfolio',
        title: 'Architectural Typography Studio',
        category: 'Minimal Portfolio',
        description:
            'Monochromatic Swiss grid layouts, fluid editorial typesetting, and frictionless transitions.',
        icon: Icons.architecture_rounded,
        accentColor: Color(0xFF059669),
        isAvailable: false,
      ),

      // 4. Nature Journal (Future Concept)
      const DesignConcept(
        id: 'nature-journal',
        title: 'Botanical Field Records',
        category: 'Nature Journal',
        description:
            'Organic textures, watercolor wash overlays, and specimen observation sheets.',
        icon: Icons.spa_rounded,
        accentColor: Color(0xFFD97706),
        isAvailable: false,
      ),
    ];
  }

  void _openDesign(DesignConcept design) async {
    if (_isNavigating) return;

    if (!design.isAvailable) {
      _showComingSoonSnackBar(design.title);
      return;
    }

    _isNavigating = true;

    if (design.id == 'motion-lab') {
      await _openMotionExperimentsModal();
    } else if (design.destinationPage != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => design.destinationPage!),
      );
    }

    if (mounted) {
      _isNavigating = false;
    }
  }

  void _showComingSoonSnackBar(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.mountainNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.mountainSecondary, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$title is in development and coming soon.',
                style: const TextStyle(fontSize: 13, color: Colors.white),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  Future<void> _openMotionExperimentsModal() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 460),
          margin: const EdgeInsets.only(top: 60),
          decoration: const BoxDecoration(
            color: AppColors.mountainCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.mountainBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Motion Design Experiments',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mountainNavy,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select any of the 5 transition demos to test individual physics and clipping:',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mountainSecondaryText,
                ),
              ),
              const SizedBox(height: 18),
              _buildModalTransitionTile(
                title: 'Circular Reveal',
                tag: 'RADIAL GEOMETRY',
                color: const Color(0xFF0284C7),
                icon: Icons.radar,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    CircularRevealPageRoute(page: const CircularDemoScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildModalTransitionTile(
                title: 'Spring Slide + Fade',
                tag: 'INERTIA PHYSICS',
                color: const Color(0xFF6366F1),
                icon: Icons.speed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    SpringSlidePageRoute(page: const SpringDemoScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildModalTransitionTile(
                title: '3D Flip Perspective',
                tag: 'MATRIX4 3D',
                color: const Color(0xFFDB2777),
                icon: Icons.view_in_ar,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    Flip3DPageRoute(page: const FlipDemoScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildModalTransitionTile(
                title: 'Liquid Swipe Wave',
                tag: 'FLUID HARMONIC',
                color: const Color(0xFF059669),
                icon: Icons.waves,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    LiquidSwipePageRoute(page: const LiquidDemoScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalTransitionTile({
    required String title,
    required String tag,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.mountainBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.mountainBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mountainNavy,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 16, color: Color(0xFF9EA3B8)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mountainBg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Brand Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.mountainCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.mountainBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome, size: 14, color: AppColors.mountainPrimary),
                            SizedBox(width: 6),
                            Text(
                              'DESIGN SHOWCASE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                                color: AppColors.mountainNavy,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.mountainPaleBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'GALLERY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: AppColors.mountainPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Header Title & Subtitle
                  const Text(
                    'Explore Designs',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppColors.mountainNavy,
                      letterSpacing: -1.2,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Discover unique interfaces, visual styles, and interactive experiences.',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.mountainSecondaryText,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Design Concepts List
                  ..._designs.map((design) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildDesignCard(design),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Clean Footer
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'PAGE TRANSITIONS LAB • DESIGN GALLERY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                            color: Color(0xFF9EA3B8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Handcrafted mobile experiences built in Flutter.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesignCard(DesignConcept design) {
    return GestureDetector(
      onTap: () => _openDesign(design),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.mountainCard,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: design.isAvailable
                ? AppColors.mountainBorder
                : AppColors.mountainBorder.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: design.isAvailable
                  ? design.accentColor.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Image or Vector Header
            if (design.previewImageUrl != null)
              Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: MountainImageWidget(
                      imageUrl: design.previewImageUrl!,
                      mountainName: design.title,
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        design.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.mountainPrimary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'LIVE DEMO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                height: 110,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      design.accentColor.withValues(alpha: 0.15),
                      design.accentColor.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: design.accentColor.withValues(alpha: 0.15),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(design.icon, color: design.accentColor, size: 26),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: design.isAvailable
                            ? design.accentColor.withValues(alpha: 0.12)
                            : Colors.grey.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        design.isAvailable ? 'AVAILABLE' : 'COMING SOON',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: design.isAvailable ? design.accentColor : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Card Body Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        design.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: design.accentColor,
                        ),
                      ),
                      if (design.isAvailable)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.mountainPaleBlue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: design.accentColor,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    design.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.mountainNavy,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    design.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.mountainSecondaryText,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
