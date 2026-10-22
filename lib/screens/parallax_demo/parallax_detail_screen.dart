import 'package:flutter/material.dart';
import '../../models/mountain_data.dart';
import '../../transitions/parallax_route.dart';
import '../../widgets/mountain_image_widget.dart';

/// Screen B — Mountain Details for Design 04 (Parallax Depth Transition).
///
/// Implements a multi-layered parallax transition with a strictly staggered timeline:
/// - Layer A (Base background): Stable #F6F5FC container at opacity 1.0 throughout.
/// - Layer B (Mountain photograph): Oversized clipped photo scales 1.06 -> 1.00
///   and translates horizontally +24px -> 0px over Interval(0.00, 0.85).
/// - Layer C (Mountain title & metadata): Translates vertically +36px -> 0px
///   and fades in 0.0 -> 1.0 over Interval(0.00, 0.70).
/// - Layer D (Information cards & overview): Translates vertically +48px -> 0px
///   and fades in 0.0 -> 1.0 over Interval(0.00, 0.85).
class ParallaxDetailScreen extends StatefulWidget {
  final MountainData mountain;
  final Animation<double>? animation;

  const ParallaxDetailScreen({
    super.key,
    required this.mountain,
    this.animation,
  });

  @override
  State<ParallaxDetailScreen> createState() => _ParallaxDetailScreenState();
}

class _ParallaxDetailScreenState extends State<ParallaxDetailScreen> {
  bool _isBookmarked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Warm image cache for the current mountain
    precacheImage(NetworkImage(widget.mountain.imageUrl), context);
  }

  @override
  Widget build(BuildContext context) {
    final mountain = widget.mountain;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    // Resolve driving route animation
    final routeAnim = widget.animation ??
        ParallaxScope.of(context)?.animation ??
        ModalRoute.of(context)?.animation ??
        kAlwaysCompleteAnimation;

    return Scaffold(
      // =======================================================================
      // Layer A: Base background
      // Stable background container matching existing lavender/off-white theme.
      // Movement: no translation or scaling. Opacity: 1.0 throughout.
      // =======================================================================
      backgroundColor: const Color(0xFFF6F5FC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: AnimatedBuilder(
              animation: routeAnim,
              builder: (context, _) {
                // -------------------------------------------------------------
                // Layer B: Mountain photograph kinematics
                // Initial scale: 1.06 -> Final scale: 1.00
                // Horizontal translation: +24px -> 0px
                // Interval: [0.00, 0.85] with Curves.easeOutCubic
                // Forward opacity: constant 1.0 throughout.
                // Reverse opacity: smooth fade 1.0 -> 0.0 with Curves.easeInOutCubic over [0.00, 0.85]
                // -------------------------------------------------------------
                final photoCurve = CurvedAnimation(
                  parent: routeAnim,
                  curve: const Interval(0.00, 0.85, curve: Curves.easeOutCubic),
                  reverseCurve: const Interval(0.00, 0.85, curve: Curves.easeInCubic),
                );
                final double photoT = disableAnimations ? 1.0 : photoCurve.value;
                final double imageScale = 1.06 - (0.06 * photoT);
                final double imageShiftX = 24.0 * (1.0 - photoT);

                final bool isReversing = routeAnim.status == AnimationStatus.reverse ||
                    (routeAnim.status == AnimationStatus.dismissed && routeAnim.value == 0.0);
                final double photoOpacity;
                if (disableAnimations || !isReversing) {
                  photoOpacity = 1.0;
                } else {
                  photoOpacity = const Interval(
                    0.00,
                    0.85,
                    curve: Curves.easeInOutCubic,
                  ).transform(routeAnim.value.clamp(0.0, 1.0));
                }

                // -------------------------------------------------------------
                // Layer C: Mountain title and metadata kinematics
                // Vertical translation: +36px -> 0px (Curves.easeOutCubic)
                // Opacity: 0.0 -> 1.0 (Curves.easeOut)
                // Reverse opacity: smooth fade with Curves.easeInOutCubic
                // Timed from 0.00 to eliminate dead-zones where only the photo shows
                // -------------------------------------------------------------
                final titleTransCurve = CurvedAnimation(
                  parent: routeAnim,
                  curve: const Interval(0.00, 0.85, curve: Curves.easeOutCubic),
                  reverseCurve: const Interval(0.00, 0.90, curve: Curves.easeInCubic),
                );
                final titleFadeCurve = CurvedAnimation(
                  parent: routeAnim,
                  curve: const Interval(0.00, 0.70, curve: Curves.easeOut),
                  reverseCurve: const Interval(0.00, 0.90, curve: Curves.easeInOutCubic),
                );
                final double titleT = disableAnimations ? 1.0 : titleTransCurve.value;
                final double titleShiftY = 36.0 * (1.0 - titleT);
                final double titleOpacity = disableAnimations ? 1.0 : titleFadeCurve.value;

                // -------------------------------------------------------------
                // Layer D: Information cards and overview kinematics
                // Vertical translation: +48px -> 0px (Curves.easeOutCubic)
                // Opacity: 0.0 -> 1.0 (Curves.easeOut)
                // Reverse opacity: smooth fade with Curves.easeInOutCubic
                // Staggers smoothly behind title and settles at 1.00, without empty frames
                // -------------------------------------------------------------
                final cardsTransCurve = CurvedAnimation(
                  parent: routeAnim,
                  curve: const Interval(0.00, 1.00, curve: Curves.easeOutCubic),
                  reverseCurve: const Interval(0.00, 1.00, curve: Curves.easeInCubic),
                );
                final cardsFadeCurve = CurvedAnimation(
                  parent: routeAnim,
                  curve: const Interval(0.00, 0.85, curve: Curves.easeOut),
                  reverseCurve: const Interval(0.00, 1.00, curve: Curves.easeInOutCubic),
                );
                final double cardsT = disableAnimations ? 1.0 : cardsTransCurve.value;
                final double cardsShiftY = 48.0 * (1.0 - cardsT);
                final double cardsOpacity = disableAnimations ? 1.0 : cardsFadeCurve.value;

                // -------------------------------------------------------------
                // Top Navigation Bar kinematics
                // -------------------------------------------------------------
                final topBarFadeCurve = CurvedAnimation(
                  parent: routeAnim,
                  curve: const Interval(0.00, 0.50, curve: Curves.easeOut),
                  reverseCurve: const Interval(0.00, 0.70, curve: Curves.easeInOutCubic),
                );
                final double topBarOpacity = disableAnimations ? 1.0 : topBarFadeCurve.value;
                final double topBarShiftY = -10.0 * (1.0 - topBarOpacity);

                return Column(
                  children: [
                    // Top Navigation Bar
                    Transform.translate(
                      offset: Offset(0, topBarShiftY),
                      child: Opacity(
                        opacity: topBarOpacity.clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Circular Back Button
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(22),
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_rounded,
                                      size: 20,
                                      color: Color(0xFF1E1B2E),
                                    ),
                                  ),
                                ),
                              ),

                              // Screen Title
                              const Text(
                                'Mountain Details',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E1B2E),
                                  letterSpacing: -0.3,
                                ),
                              ),

                              // Bookmark Icon
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(22),
                                  onTap: () {
                                    setState(() {
                                      _isBookmarked = !_isBookmarked;
                                    });
                                  },
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
                                      size: 20,
                                      color: _isBookmarked
                                          ? const Color(0xFF7C3AED)
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Scrollable Body Content
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // =========================================================
                            // Layer B: Mountain Photograph
                            // Clipped to container, scales 1.06 -> 1.00 and translates
                            // horizontally +24px -> 0px over Interval(0.00, 0.85).
                            // Oversized viewport prevents exposed edges.
                            // Forward opacity: constant 1.0 throughout.
                            // Reverse opacity: smooth coordinated fade out with Curves.easeInOutCubic.
                            // =========================================================
                            Opacity(
                              opacity: photoOpacity.clamp(0.0, 1.0),
                              child: Container(
                                height: 230,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF18274B).withValues(alpha: 0.08),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Moving & Scaling Mountain Image
                                    Transform.translate(
                                      offset: Offset(imageShiftX, 0),
                                      child: Transform.scale(
                                        scale: imageScale,
                                        child: FractionallySizedBox(
                                          widthFactor: 1.25,
                                          heightFactor: 1.25,
                                          child: MountainImageWidget(
                                            imageUrl: mountain.imageUrl,
                                            mountainName: mountain.name,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Atmospheric gradient overlay for contrast & depth
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withValues(alpha: 0.15),
                                              Colors.transparent,
                                              Colors.black.withValues(alpha: 0.55),
                                            ],
                                            stops: const [0.0, 0.45, 1.0],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Overlaid Mountain Type Badge
                                    Positioned(
                                      bottom: 14,
                                      left: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF7C3AED),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          mountain.mountainType.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // =========================================================
                            // Layer C: Mountain Title & Metadata
                            // Translates vertically +36px -> 0px and fades 0.0 -> 1.0
                            // over Interval(0.00, 0.70)
                            // =========================================================
                            Transform.translate(
                              offset: Offset(0, titleShiftY),
                              child: Opacity(
                                opacity: titleOpacity.clamp(0.0, 1.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mountain.name,
                                            style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF1E1B2E),
                                              letterSpacing: -0.6,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            mountain.localName,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF64748B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                size: 15,
                                                color: Color(0xFF7C3AED),
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  mountain.location,
                                                  style: const TextStyle(
                                                    fontSize: 12.5,
                                                    color: Color(0xFF64748B),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3E8FF),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: const Color(0xFFEDE9FE)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            mountain.shortElevation,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF7C3AED),
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          const Text(
                                            'Summit Elevation',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF6B21A8),
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),

                            // =========================================================
                            // Layer D: Information Cards & Overview
                            // Translates vertically +48px -> 0px and fades 0.0 -> 1.0
                            // over Interval(0.00, 0.85)
                            // =========================================================
                            Transform.translate(
                              offset: Offset(0, cardsShiftY),
                              child: Opacity(
                                opacity: cardsOpacity.clamp(0.0, 1.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Key Metrics Grid
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildMetricTile(
                                            icon: Icons.height_rounded,
                                            label: 'Elevation',
                                            value: mountain.elevation,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _buildMetricTile(
                                            icon: Icons.terrain_rounded,
                                            label: 'Range',
                                            value: mountain.range,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildMetricTile(
                                            icon: Icons.history_edu_rounded,
                                            label: 'First Ascent',
                                            value: mountain.firstAscentYear,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _buildMetricTile(
                                            icon: Icons.flag_rounded,
                                            label: 'Base Camp',
                                            value: mountain.baseCampElevation,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 22),

                                    // Expedition Overview Card
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.02),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Expedition Overview',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF1E1B2E),
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            mountain.description,
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              color: Color(0xFF64748B),
                                              height: 1.55,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                          const SizedBox(height: 14),
                                          _buildDetailRow(
                                            icon: Icons.route_rounded,
                                            label: 'Standard Route',
                                            value: mountain.expeditionRoute,
                                          ),
                                          const SizedBox(height: 10),
                                          _buildDetailRow(
                                            icon: Icons.wb_sunny_outlined,
                                            label: 'Climbing Season',
                                            value: mountain.climbingSeason,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF7C3AED)),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF7C3AED)),
        const SizedBox(width: 8),
        SizedBox(
          width: 115,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1B2E),
            ),
          ),
        ),
      ],
    );
  }
}
