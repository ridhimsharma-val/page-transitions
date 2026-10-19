import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'hero_demo_screen.dart';
import 'circular_demo_screen.dart';
import 'spring_demo_screen.dart';
import 'flip_demo_screen.dart';
import 'liquid_demo_screen.dart';

import '../transitions/circular_reveal_route.dart';
import '../transitions/spring_slide_route.dart';
import '../transitions/flip_3d_route.dart';
import '../transitions/liquid_swipe_route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilterIndex = 1; // "02 8,000m+" selected by default
  bool _isNavigating = false;

  final List<String> _filters = [
    '01 All Peaks',
    '02 8,000m+',
    '03 Himalayas',
    '04 Karakoram',
    '05 Seven Summits',
  ];

  static const String _everestImageUrl =
      'https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=1200&auto=format&fit=crop';
  static const String _k2ImageUrl =
      'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?q=80&w=800&auto=format&fit=crop';
  static const String _kangchenjungaImageUrl =
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=800&auto=format&fit=crop';

  void _openMountainDetail({
    required String title,
    required String elevation,
    required String range,
    required String imageUrl,
  }) async {
    if (_isNavigating) return;
    _isNavigating = true;

    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return MountainDetailScreen(
            imageUrl: imageUrl,
            title: title,
            elevation: elevation,
            range: range,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
            ),
            child: child,
          );
        },
      ),
    );

    if (mounted) {
      _isNavigating = false;
    }
  }

  void _navigateToTransition(String transitionType) async {
    if (_isNavigating) return;
    _isNavigating = true;

    Route route;
    switch (transitionType) {
      case 'hero':
        route = PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 650),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => const MountainDetailScreen(
            imageUrl: _everestImageUrl,
            title: 'Mount Everest',
            elevation: '8,848.86 m',
            range: 'Mahalangur Himal • Nepal / Tibet',
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
        break;
      case 'circular':
        route = CircularRevealPageRoute(page: const CircularDemoScreen());
        break;
      case 'spring':
        route = SpringSlidePageRoute(page: const SpringDemoScreen());
        break;
      case 'flip':
        route = Flip3DPageRoute(page: const FlipDemoScreen());
        break;
      case 'liquid':
        route = LiquidSwipePageRoute(page: const LiquidDemoScreen());
        break;
      default:
        route = MaterialPageRoute(
          builder: (_) => const MountainDetailScreen(
            imageUrl: _everestImageUrl,
            title: 'Mount Everest',
            elevation: '8,848.86 m',
            range: 'Mahalangur Himal • Nepal / Tibet',
          ),
        );
    }

    await Navigator.of(context).push(route);

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
            child: Column(
              children: [
                // Compact Top Bar with App Identity & Motion Badge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                              Icon(Icons.landscape, size: 14, color: AppColors.mountainPrimary),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'WORLD ABOVE 8,000M',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: AppColors.mountainNavy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.mountainPaleBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.motion_photos_on, size: 13, color: AppColors.mountainPrimary),
                            SizedBox(width: 4),
                            Text(
                              '5 TRANSITIONS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: AppColors.mountainPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Compact Pill / Filter Selector (Exact match to reference style)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EBF5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(_filters.length, (index) {
                        final isSelected = index == _selectedFilterIndex;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilterIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              _filters[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.mountainPillActive
                                    : AppColors.mountainSecondaryText,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // Main Mobile Content Scrollable Area
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),

                        // Title: World Above 8,000 Metres
                        const Text(
                          'World Above\n8,000 Metres',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppColors.mountainNavy,
                            letterSpacing: -1.0,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        const Text(
                          'Explore the highest peaks on Earth, one story at a time.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mountainSecondaryText,
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Featured Mountain Card: Mount Everest with Hero image
                        GestureDetector(
                          onTap: () => _openMountainDetail(
                            title: 'Mount Everest',
                            elevation: '8,848.86 m',
                            range: 'Mahalangur Himal • Nepal / Tibet',
                            imageUrl: _everestImageUrl,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.mountainCard,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: AppColors.mountainBorder),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mountainPrimary.withValues(alpha: 0.08),
                                  blurRadius: 28,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hero Photograph
                                Hero(
                                  tag: 'featured-mountain-image',
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 260,
                                        width: double.infinity,
                                        child: Image.network(
                                          _everestImageUrl,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, progress) {
                                            if (progress == null) return child;
                                            return _buildImagePlaceholder();
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return _buildImagePlaceholder();
                                          },
                                        ),
                                      ),
                                      // Top Altitude Pill
                                      Positioned(
                                        top: 16,
                                        right: 16,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.55),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Colors.white.withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.arrow_upward,
                                                size: 13,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                '8,848.86 m',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Bottom gradient for legibility
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        height: 50,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withValues(alpha: 0.4),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Mountain Metadata Content
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Hero(
                                                  tag: 'featured-mountain-title',
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      'Mount Everest',
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.w800,
                                                        color: AppColors.mountainNavy,
                                                        letterSpacing: -0.4,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Mahalangur Himal • Nepal / Tibet',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: AppColors.mountainSecondaryText,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: AppColors.mountainPaleBlue,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.mountainSecondary.withValues(alpha: 0.5),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              size: 18,
                                              color: AppColors.mountainPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.mountainBg,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppColors.mountainBorder),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.auto_awesome,
                                              size: 15,
                                              color: AppColors.mountainPrimary,
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Tap to trigger shared-element Hero transition',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.mountainSecondaryText,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Secondary Mountain Explorer Row: K2 and Kangchenjunga
                        const Text(
                          'OTHER NOTABLE GIANTS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: AppColors.mountainSecondaryText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSecondaryPeakCard(
                                name: 'K2',
                                elevation: '8,611 m',
                                range: 'Karakoram Range',
                                imageUrl: _k2ImageUrl,
                                iconColor: AppColors.accentCyan,
                                onTap: () => _openMountainDetail(
                                  title: 'K2 (Chhogori)',
                                  elevation: '8,611 m',
                                  range: 'Karakoram • Pakistan / China',
                                  imageUrl: _k2ImageUrl,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSecondaryPeakCard(
                                name: 'Kangchenjunga',
                                elevation: '8,586 m',
                                range: 'Eastern Himalaya',
                                imageUrl: _kangchenjungaImageUrl,
                                iconColor: AppColors.accentPink,
                                onTap: () => _openMountainDetail(
                                  title: 'Kangchenjunga',
                                  elevation: '8,586 m',
                                  range: 'Eastern Himalaya • Nepal / India',
                                  imageUrl: _kangchenjungaImageUrl,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

                        // SECTION: Explore Motion
                        const Text(
                          'Explore Motion',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.mountainNavy,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Discover how each transition transforms the experience.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.mountainSecondaryText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 5 Transition Experiment Cards
                        _buildTransitionItem(
                          title: 'Hero / Shared Element',
                          tag: 'SPATIAL FLIGHT',
                          description:
                              'Continuous physical persistence expanding Mount Everest seamlessly across screen boundaries.',
                          accentColor: AppColors.primaryViolet,
                          icon: Icons.auto_awesome,
                          onTap: () => _navigateToTransition('hero'),
                        ),
                        const SizedBox(height: 12),

                        _buildTransitionItem(
                          title: 'Circular Reveal',
                          tag: 'RADIAL GEOMETRY',
                          description:
                              'Aperture expands radially from the touch epicenter using Euclidean corner clipping and luminous shockwave.',
                          accentColor: AppColors.accentCyan,
                          icon: Icons.radar,
                          onTap: () => _navigateToTransition('circular'),
                        ),
                        const SizedBox(height: 12),

                        _buildTransitionItem(
                          title: 'Spring Slide + Fade',
                          tag: 'INERTIA PHYSICS',
                          description:
                              'Damped harmonic spring simulation (γ=16, k=180) coupled with secondary 25% parallax depth.',
                          accentColor: const Color(0xFF6366F1),
                          icon: Icons.speed,
                          onTap: () => _navigateToTransition('spring'),
                        ),
                        const SizedBox(height: 12),

                        _buildTransitionItem(
                          title: '3D Flip Perspective',
                          tag: 'MATRIX4 3D',
                          description:
                              'Affine 4x4 perspective transformation matrix with focal depth and glancing shadow falloff.',
                          accentColor: AppColors.accentPink,
                          icon: Icons.view_in_ar,
                          onTap: () => _navigateToTransition('flip'),
                        ),
                        const SizedBox(height: 12),

                        _buildTransitionItem(
                          title: 'Liquid Swipe Wave',
                          tag: 'FLUID HARMONIC',
                          description:
                              'Non-linear sinusoidal wave sweep driven by dynamic 40-step Bezier harmonic morphing.',
                          accentColor: AppColors.accentEmerald,
                          icon: Icons.waves,
                          onTap: () => _navigateToTransition('liquid'),
                        ),
                        const SizedBox(height: 40),

                        // Mobile Footer
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'PAGE TRANSITIONS LAB • MOUNTAIN EDITION',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.4,
                                  color: Color(0xFF9EA3B8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Motion design playground powered by pure Flutter animation primitives.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryPeakCard({
    required String name,
    required String elevation,
    required String range,
    required String imageUrl,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mountainCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.mountainBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: iconColor.withValues(alpha: 0.15),
                  child: Center(
                    child: Icon(Icons.terrain, color: iconColor, size: 28),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        elevation,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: iconColor,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFF9EA3B8)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.mountainNavy,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    range,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.mountainSecondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitionItem({
    required String title,
    required String tag,
    required String description,
    required Color accentColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.mountainCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.mountainBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.mountainNavy,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mountainSecondaryText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 13,
                color: Color(0xFFB0B5C9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8065F5),
            Color(0xFF3B82F6),
            Color(0xFF1E1B4B),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.terrain, size: 64, color: Colors.white70),
      ),
    );
  }
}
