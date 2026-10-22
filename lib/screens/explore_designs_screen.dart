import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'mountain_page.dart';
import 'shared_axis_demo/shared_axis_explore_screen.dart';
import 'zoom_fade_demo/zoom_fade_explore_screen.dart';
import 'parallax_demo/parallax_explore_screen.dart';
import 'circular_carousel_demo/circular_carousel_explore_screen.dart';
import 'cloudstorm_demo/cloudstorm_explore_screen.dart';

class DesignConcept {
  final String id;
  final String designNumber;
  final String title;
  final Widget destinationPage;

  const DesignConcept({
    required this.id,
    required this.designNumber,
    required this.title,
    required this.destinationPage,
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
    _designs = const [
      // 1. Design 01 — Hero Transition
      DesignConcept(
        id: 'mountain-world',
        designNumber: 'Design 01',
        title: 'Hero Transition',
        destinationPage: MountainPage(),
      ),

      // 2. Design 02 — Shared-Axis Transition
      DesignConcept(
        id: 'shared-axis-transition',
        designNumber: 'Design 02',
        title: 'Shared-Axis Transition',
        destinationPage: SharedAxisExploreScreen(),
      ),

      // 3. Design 03 — Zoom & Fade Transition
      DesignConcept(
        id: 'zoom-fade-transition',
        designNumber: 'Design 03',
        title: 'Zoom & Fade Transition',
        destinationPage: ZoomFadeExploreScreen(),
      ),

      // 4. Design 04 — Parallax Depth
      DesignConcept(
        id: 'parallax-depth-transition',
        designNumber: 'Design 04',
        title: 'Parallax Depth',
        destinationPage: ParallaxExploreScreen(),
      ),

      // 5. Design 05 — Circular Carousel
      DesignConcept(
        id: 'circular-carousel-reveal',
        designNumber: 'Design 05',
        title: 'Circular Carousel',
        destinationPage: CircularCarouselExploreScreen(),
      ),

      // 6. Design 06 — Cloudstorm Reveal
      DesignConcept(
        id: 'cloudstorm-reveal',
        designNumber: 'Design 06',
        title: 'Cloudstorm Reveal',
        destinationPage: CloudstormExploreScreen(),
      ),
    ];
  }

  void _openDesign(DesignConcept design) async {
    if (_isNavigating) return;
    _isNavigating = true;

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => design.destinationPage),
    );

    if (mounted) {
      _isNavigating = false;
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // Design Concepts List: showing only Design No and Design Name
                  ..._designs.map((design) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
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
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mountainCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.mountainBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    design.designNumber,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    design.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.mountainNavy,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Color(0xFF9EA3B8),
            ),
          ],
        ),
      ),
    );
  }
}
