import 'package:flutter/material.dart';
import '../../models/mountain_data.dart';
import '../../transitions/shared_element_morph_route.dart';
import '../../widgets/mountain_image_widget.dart';

/// Details screen for Design 06 — Shared Element Morph.
///
/// Implements the exact forward transition timeline:
/// - Shared mountain image: 0% -> 100% (Hero flight with Curves.easeInOutCubic)
/// - Image corner radius: 0% -> 78% (Morph card corners into destination 32px bottom radius)
/// - Destination background/header: 20% -> 72% (Fade in with Curves.easeOutCubic)
/// - Mountain title: 11% -> 72% (Fade in + 16px upward translation)
/// - Elevation and location metadata: 20% -> 76% (Fade in + 14px upward translation)
/// - Overview card: 39% -> 84% (Fade in + 18px upward slide)
/// - Additional information cards: 50% -> 94% (Staggered fade in + 20px upward slide)
/// - Final settling: 84% -> 100% (Subtle settling curve with Curves.easeOut)
class SharedElementDetailScreen extends StatelessWidget {
  final MountainData mountain;

  const SharedElementDetailScreen({
    super.key,
    required this.mountain,
  });

  @override
  Widget build(BuildContext context) {
    final routeAnim = SharedElementMorphScope.of(context)?.animation ??
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
          // 1. Destination background / header: 20% -> 72% (Curves.easeOutCubic)
          // -------------------------------------------------------------------
          final double bgProgress = isReversing
              ? const Interval(0.20, 0.72, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.20, 0.72, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double bgOpacity = disableAnimations ? 1.0 : bgProgress;

          // -------------------------------------------------------------------
          // 2. Mountain title: 11% -> 72% (Curves.easeOutCubic)
          // Fade in + 16px upward translation
          // -------------------------------------------------------------------
          final double titleProgress = isReversing
              ? const Interval(0.11, 0.72, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.11, 0.72, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double titleOpacity = disableAnimations ? 1.0 : titleProgress;
          final double titleTranslateY =
              disableAnimations ? 0.0 : 16.0 * (1.0 - titleProgress);

          // -------------------------------------------------------------------
          // 3. Elevation & Location metadata: 20% -> 76% (Curves.easeOutCubic)
          // Fade in + 14px upward translation
          // -------------------------------------------------------------------
          final double metaProgress = isReversing
              ? const Interval(0.20, 0.76, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.20, 0.76, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double metaOpacity = disableAnimations ? 1.0 : metaProgress;
          final double metaTranslateY =
              disableAnimations ? 0.0 : 14.0 * (1.0 - metaProgress);

          // -------------------------------------------------------------------
          // 4. Overview card: 39% -> 84% (Curves.easeOutCubic)
          // Fade in + 18px upward slide
          // -------------------------------------------------------------------
          final double overviewProgress = isReversing
              ? const Interval(0.39, 0.84, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.39, 0.84, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double overviewOpacity =
              disableAnimations ? 1.0 : overviewProgress;
          final double overviewTranslateY =
              disableAnimations ? 0.0 : 18.0 * (1.0 - overviewProgress);

          // -------------------------------------------------------------------
          // 5. Additional information cards: 50% -> 94% (Curves.easeOutCubic)
          // Staggered fade in + 20px upward slide
          // -------------------------------------------------------------------
          final double cardsProgress = isReversing
              ? const Interval(0.50, 0.94, curve: Curves.easeInOutCubic)
                  .transform(progress)
              : const Interval(0.50, 0.94, curve: Curves.easeOutCubic)
                  .transform(progress);
          final double cardsOpacity = disableAnimations ? 1.0 : cardsProgress;
          final double cardsTranslateY =
              disableAnimations ? 0.0 : 20.0 * (1.0 - cardsProgress);

          // -------------------------------------------------------------------
          // 6. Final settling: 84% -> 100% (Curves.easeOut)
          // -------------------------------------------------------------------
          final double settleProgress = disableAnimations
              ? 1.0
              : const Interval(0.84, 1.00, curve: Curves.easeOut)
                  .transform(progress);
          final double settleScale =
              disableAnimations ? 1.0 : (0.995 + 0.005 * settleProgress);

          return Container(
            color: const Color(0xFFF6F5FC).withValues(alpha: bgOpacity),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Stack(
                    children: [
                      // Scrollable Details Content
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Transform.scale(
                          scale: settleScale,
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // -----------------------------------------------
                              // Top Destination Hero Photograph (360px)
                              // -----------------------------------------------
                              SizedBox(
                                height: 360,
                                width: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Hero(
                                      tag: 'morph-mountain-image-${mountain.id}',
                                      createRectTween: (begin, end) =>
                                          CurvedRectTween(
                                        begin: begin,
                                        end: end,
                                        curve: Curves.easeInOutCubic,
                                      ),
                                      flightShuttleBuilder: (
                                        flightContext,
                                        animation,
                                        flightDirection,
                                        fromHeroContext,
                                        toHeroContext,
                                      ) {
                                        return buildSharedElementFlightShuttle(
                                          flightContext: flightContext,
                                          animation: animation,
                                          flightDirection: flightDirection,
                                          fromHeroContext: fromHeroContext,
                                          toHeroContext: toHeroContext,
                                          mountain: mountain,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(32.0),
                                          bottomRight: Radius.circular(32.0),
                                        ),
                                        child: SizedBox(
                                          height: 360,
                                          width: double.infinity,
                                          child: MountainImageWidget(
                                            imageUrl: mountain.imageUrl,
                                            mountainName: mountain.name,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Subtle atmospheric gradient overlay for readability
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(32.0),
                                            bottomRight: Radius.circular(32.0),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withValues(alpha: 0.35),
                                              Colors.transparent,
                                              Colors.black.withValues(alpha: 0.70),
                                            ],
                                            stops: const [0.0, 0.45, 1.0],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Top Right Elevation Pill
                                    Positioned(
                                      top: 48,
                                      right: 18,
                                      child: Opacity(
                                        opacity: bgOpacity,
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
                                                    .withValues(alpha: 0.2),
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

                              // -----------------------------------------------
                              // Details Body Content with Staggered Arrivals
                              // -----------------------------------------------
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Layer 1: Mountain Title (11% -> 72%)
                                    Transform.translate(
                                      offset: Offset(0, titleTranslateY),
                                      child: Opacity(
                                        opacity: titleOpacity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    mountain.name,
                                                    style: const TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Color(0xFF1E1B2E),
                                                      letterSpacing: -0.6,
                                                      height: 1.15,
                                                    ),
                                                  ),
                                                ),
                                              ],
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

                                    // Layer 2: Elevation and Location Metadata (20% -> 76%)
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
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
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

                                    // Layer 3: Overview Card (39% -> 84%)
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

                                    // Layer 4: Additional Information Cards (50% -> 94%)
                                    Transform.translate(
                                      offset: Offset(0, cardsTranslateY),
                                      child: Opacity(
                                        opacity: cardsOpacity,
                                        child: Column(
                                          children: [
                                            // Key Statistics Grid
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
                                                    value: mountain
                                                        .climbingSeason,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: _buildMetricTile(
                                                    icon: Icons.flag_rounded,
                                                    label: 'First Ascent',
                                                    value: mountain
                                                        .firstAscentYear,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 16),

                                            // Expedition Route Card
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFFE2E8F0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFF1E1B2E)
                                                            .withValues(
                                                                alpha: 0.03),
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.route_rounded,
                                                        size: 16,
                                                        color:
                                                            Color(0xFF7C3AED),
                                                      ),
                                                      SizedBox(width: 6),
                                                      Expanded(
                                                        child: Text(
                                                          'Standard Expedition Route',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Color(0xFF1E1B2E),
                                                          ),
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    mountain.expeditionRoute,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF64748B),
                                                      height: 1.4,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Wrap(
                                                    spacing: 6,
                                                    runSpacing: 6,
                                                    children: mountain.camps
                                                        .map(
                                                          (camp) => Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 10,
                                                              vertical: 4,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFFF1F5F9),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Text(
                                                              camp,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xFF334155),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
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
                      ),

                      // Floating Circular Back Button
                      Positioned(
                        top: 44,
                        left: 18,
                        child: Opacity(
                          opacity: bgOpacity,
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
