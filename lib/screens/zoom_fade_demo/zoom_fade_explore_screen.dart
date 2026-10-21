import 'package:flutter/material.dart';
import '../../models/mountain_data.dart';
import '../../transitions/zoom_fade_route.dart';
import '../../widgets/mountain_image_widget.dart';
import 'zoom_fade_detail_screen.dart';

/// Screen A — Explore Mountains for Design 03 (Zoom & Fade Transition).
///
/// Features a curated list of eight-thousander peaks with a featured card
/// and supporting mountain tiles, wrapped in [ZoomFadePageWrapper] to recede
/// subtly when a detail screen is pushed.
class ZoomFadeExploreScreen extends StatefulWidget {
  const ZoomFadeExploreScreen({super.key});

  @override
  State<ZoomFadeExploreScreen> createState() => _ZoomFadeExploreScreenState();
}

class _ZoomFadeExploreScreenState extends State<ZoomFadeExploreScreen> {
  bool _isNavigating = false;

  void _openDetail(MountainData mountain) async {
    if (_isNavigating) return;
    _isNavigating = true;

    try {
      await Navigator.of(context).push(
        ZoomFadePageRoute(
          page: ZoomFadeDetailScreen(mountain: mountain),
        ),
      );
    } finally {
      if (mounted) {
        _isNavigating = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FC),
      body: ZoomFadePageWrapper(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top App Header
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE9FE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'PEAKS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.3,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1B2E),
                            letterSpacing: -0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Introductory Subtitle
                    const Text(
                      'Discover the world\'s highest mountains.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Featured Mountain Card (Mount Everest)
                    GestureDetector(
                      onTap: () => _openDetail(MountainData.everest),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF18274B).withValues(alpha: 0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Image with Tag
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  MountainImageWidget(
                                    imageUrl: MountainData.everest.imageUrl,
                                    mountainName: MountainData.everest.name,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 14,
                                    left: 14,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.65),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'FEATURED EXPEDITION',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    right: 14,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.92),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        MountainData.everest.shortElevation,
                                        style: const TextStyle(
                                          color: Color(0xFF1E1B2E),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Card Information Body
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          MountainData.everest.name,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1E1B2E),
                                            letterSpacing: -0.4,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 14,
                                            color: Color(0xFF7C3AED),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            MountainData.everest.shortLocation,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF64748B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    MountainData.everest.description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                      height: 1.45,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),

                                  // Primary Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 46,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF7C3AED),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      onPressed: () => _openDetail(MountainData.everest),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Explore Mountain',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Icon(Icons.arrow_forward_rounded, size: 16),
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
                    const SizedBox(height: 24),

                    // Section Heading: Other Peaks
                    const Text(
                      'Other Peaks',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1B2E),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Supporting Entry 1: K2
                    _buildSupportingMountainTile(
                      mountain: MountainData.k2,
                      onTap: () => _openDetail(MountainData.k2),
                    ),
                    const SizedBox(height: 10),

                    // Supporting Entry 2: Kangchenjunga
                    _buildSupportingMountainTile(
                      mountain: MountainData.kangchenjunga,
                      onTap: () => _openDetail(MountainData.kangchenjunga),
                    ),
                    const SizedBox(height: 10),

                    // Supporting Entry 3: Lhotse
                    _buildSupportingMountainTile(
                      mountain: MountainData.lhotse,
                      onTap: () => _openDetail(MountainData.lhotse),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportingMountainTile({
    required MountainData mountain,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                clipBehavior: Clip.antiAlias,
                child: MountainImageWidget(
                  imageUrl: mountain.imageUrl,
                  mountainName: mountain.name,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mountain.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1B2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${mountain.shortElevation} • ${mountain.shortLocation}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E8FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF7C3AED),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
