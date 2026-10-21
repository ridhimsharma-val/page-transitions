import 'package:flutter/material.dart';
import '../../models/mountain_data.dart';
import '../../widgets/mountain_image_widget.dart';

/// Screen B — Mountain Details for Design 03 (Zoom & Fade Transition).
///
/// Displays detailed mountain photograph, statistics, range info, and
/// overview text using the selected [MountainData] dynamically.
class ZoomFadeDetailScreen extends StatefulWidget {
  final MountainData mountain;

  const ZoomFadeDetailScreen({
    super.key,
    required this.mountain,
  });

  @override
  State<ZoomFadeDetailScreen> createState() => _ZoomFadeDetailScreenState();
}

class _ZoomFadeDetailScreenState extends State<ZoomFadeDetailScreen> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final mountain = widget.mountain;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              children: [
                // Top Navigation Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Accessible Circular Back Button
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

                      // Title
                      const Text(
                        'Mountain Details',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1B2E),
                          letterSpacing: -0.3,
                        ),
                      ),

                      // Action Icon (Bookmark toggle)
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

                // Scrollable Body Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Large Mountain Image Banner (No Hero)
                        Container(
                          height: 230,
                          width: double.infinity,
                          decoration: BoxDecoration(
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
                              MountainImageWidget(
                                imageUrl: mountain.imageUrl,
                                mountainName: mountain.name,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 80,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
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
                        const SizedBox(height: 20),

                        // 2. Title, Tagline, & Elevation Header
                        Row(
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
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const Text(
                                    'Elevation',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        // 3. Three Key Info Metric Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.height_rounded,
                                title: mountain.shortElevation,
                                label: 'Elevation',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.terrain_rounded,
                                title: mountain.range,
                                label: 'Range',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.flag_rounded,
                                title: mountain.firstAscentYear,
                                label: 'First Ascent',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        // 4. Detailed Mountain Overview Text Card
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
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Expedition Overview',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E1B2E),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                mountain.description,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF475569),
                                  height: 1.6,
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF7C3AED)),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
