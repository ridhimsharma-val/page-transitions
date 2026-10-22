import 'package:flutter/material.dart';
import '../../models/mountain_data.dart';
import '../../transitions/cloudstorm_route.dart';
import '../../widgets/mountain_image_widget.dart';

/// Details screen for Design 06 — Cloudstorm Reveal.
///
/// Implements the exact destination reveal intervals:
/// - Mountain image/background: 50% -> 82% (Gradually emerges through clearing mist)
/// - Mountain title: 57% -> 82% (Fade in with subtle 12px upward movement)
/// - Elevation/location metadata: 62% -> 85% (Fade in after title + 10px upward movement)
/// - Overview card: 68% -> 90% (Fade in with subtle 14px upward movement)
/// - Additional information cards: 74% -> 95% (Staggered fade in + 16px upward movement)
class CloudstormDetailScreen extends StatelessWidget {
  final MountainData mountain;

  const CloudstormDetailScreen({
    super.key,
    required this.mountain,
  });

  @override
  Widget build(BuildContext context) {
    final routeAnim = CloudstormScope.of(context)?.animation ??
        ModalRoute.of(context)?.animation ??
        kAlwaysCompleteAnimation;

    final bool disableAnimations = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: routeAnim,
        builder: (context, _) {
          final double progress = disableAnimations
              ? 1.0
              : routeAnim.value.clamp(0.0, 1.0);

          final bool isReversing = !disableAnimations &&
              (routeAnim.status == AnimationStatus.reverse ||
                  (routeAnim.status == AnimationStatus.dismissed &&
                      routeAnim.value == 0.0));

          // -------------------------------------------------------------------
          // Destination Background: Emerges during peak obscuration (45% -> 65%)
          // -------------------------------------------------------------------
          final double bgProgress = isReversing
              ? const Interval(0.40, 0.65, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.45, 0.65, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double bgOpacity = disableAnimations ? 1.0 : bgProgress;

          // -------------------------------------------------------------------
          // 1. Mountain image/background: 50% -> 82% (Curves.easeOutCubic)
          // Gradually emerges through the clearing mist
          // -------------------------------------------------------------------
          final double imageProgress = isReversing
              ? const Interval(0.50, 0.82, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.50, 0.82, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double imageOpacity = disableAnimations ? 1.0 : imageProgress;

          // -------------------------------------------------------------------
          // 2. Mountain title: 57% -> 82% (Curves.easeOutCubic)
          // Fade in with subtle 12px upward movement
          // -------------------------------------------------------------------
          final double titleProgress = isReversing
              ? const Interval(0.57, 0.82, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.57, 0.82, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double titleOpacity = disableAnimations ? 1.0 : titleProgress;
          final double titleTranslateY =
              disableAnimations ? 0.0 : 12.0 * (1.0 - titleProgress);

          // -------------------------------------------------------------------
          // 3. Elevation & location metadata: 62% -> 85% (Curves.easeOutCubic)
          // Fade in after title with subtle 10px upward movement
          // -------------------------------------------------------------------
          final double metaProgress = isReversing
              ? const Interval(0.62, 0.85, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.62, 0.85, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double metaOpacity = disableAnimations ? 1.0 : metaProgress;
          final double metaTranslateY =
              disableAnimations ? 0.0 : 10.0 * (1.0 - metaProgress);

          // -------------------------------------------------------------------
          // 4. Overview card: 68% -> 90% (Curves.easeOutCubic)
          // Fade in with subtle 14px upward movement
          // -------------------------------------------------------------------
          final double overviewProgress = isReversing
              ? const Interval(0.68, 0.90, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.68, 0.90, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double overviewOpacity =
              disableAnimations ? 1.0 : overviewProgress;
          final double overviewTranslateY =
              disableAnimations ? 0.0 : 14.0 * (1.0 - overviewProgress);

          // -------------------------------------------------------------------
          // 5. Additional information cards: 74% -> 95% (Curves.easeOutCubic)
          // Staggered fade in with 16px upward movement
          // -------------------------------------------------------------------
          final double cardsProgress = isReversing
              ? const Interval(0.74, 0.95, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.74, 0.95, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double cardsOpacity = disableAnimations ? 1.0 : cardsProgress;
          final double cardsTranslateY =
              disableAnimations ? 0.0 : 16.0 * (1.0 - cardsProgress);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                color: const Color(0xFFF6F5FC).withValues(alpha: bgOpacity),
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Stack(
                    children: [
                      // Scrollable Mountain Details
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // -------------------------------------------------
                            // Mountain Photograph (50% -> 82% reveal)
                            // -------------------------------------------------
                            SizedBox(
                              height: 360,
                              width: double.infinity,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Opacity(
                                    opacity: imageOpacity,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(28.0),
                                        bottomRight: Radius.circular(28.0),
                                      ),
                                      child: MountainImageWidget(
                                        imageUrl: mountain.imageUrl,
                                        mountainName: mountain.name,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // Atmospheric gradient overlay for contrast
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: imageOpacity,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(28.0),
                                            bottomRight: Radius.circular(28.0),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black
                                                  .withValues(alpha: 0.35),
                                              Colors.transparent,
                                              Colors.black
                                                  .withValues(alpha: 0.70),
                                            ],
                                            stops: const [0.0, 0.45, 1.0],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Top Elevation Badge
                                  Positioned(
                                    top: 48,
                                    right: 18,
                                    child: Opacity(
                                      opacity: imageOpacity,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF7C3AED),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.20),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          mountain.shortElevation,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // -------------------------------------------------
                            // Details Body Content
                            // -------------------------------------------------
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Element 1: Mountain Title (57% -> 82%)
                                  Transform.translate(
                                    offset: Offset(0, titleTranslateY),
                                    child: Opacity(
                                      opacity: titleOpacity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mountain.name,
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF1E1B2E),
                                              letterSpacing: -0.6,
                                              height: 1.15,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            mountain.localName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                              color: Color(0xFF7C3AED),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Element 2: Elevation & Location Metadata (62% -> 85%)
                                  Transform.translate(
                                    offset: Offset(0, metaTranslateY),
                                    child: Opacity(
                                      opacity: metaOpacity,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_rounded,
                                            size: 16,
                                            color: Color(0xFF7C3AED),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              '${mountain.range} • ${mountain.location}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF64748B),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEDE9FE),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              mountain.mountainType
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF7C3AED),
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Element 3: Overview Card (68% -> 90%)
                                  Transform.translate(
                                    offset: Offset(0, overviewTranslateY),
                                    child: Opacity(
                                      opacity: overviewOpacity,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: const Color(0xFFE2E8F0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF1E1B2E)
                                                  .withValues(alpha: 0.03),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Overview',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF1E1B2E),
                                                letterSpacing: -0.3,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              mountain.description,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF475569),
                                                height: 1.5,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Element 4: Additional Information Cards (74% -> 95%)
                                  Transform.translate(
                                    offset: Offset(0, cardsTranslateY),
                                    child: Opacity(
                                      opacity: cardsOpacity,
                                      child: Column(
                                        children: [
                                          // Metrics Grid
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildMetricTile(
                                                  icon: Icons.height_rounded,
                                                  label: 'Peak Elevation',
                                                  value: mountain.elevation,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: _buildMetricTile(
                                                  icon: Icons.cabin_rounded,
                                                  label: 'Base Camp',
                                                  value: mountain
                                                      .baseCampElevation,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 12),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildMetricTile(
                                                  icon: Icons
                                                      .calendar_today_rounded,
                                                  label: 'Climbing Season',
                                                  value:
                                                      mountain.climbingSeason,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: _buildMetricTile(
                                                  icon: Icons.flag_rounded,
                                                  label: 'First Ascent',
                                                  value:
                                                      mountain.firstAscentYear,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Floating Circular Back Button (Fades in with title 57% -> 82%)
                      Positioned(
                        top: 44,
                        left: 18,
                        child: Opacity(
                          opacity: titleOpacity,
                          child: Material(
                            color: Colors.white.withValues(alpha: 0.94),
                            shape: const CircleBorder(),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => Navigator.of(context).maybePop(),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  size: 20,
                                  color: Color(0xFF1E1B2E),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1B2E).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF7C3AED)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1B2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
