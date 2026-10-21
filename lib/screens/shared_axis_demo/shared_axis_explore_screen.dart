import 'package:flutter/material.dart';
import '../../transitions/shared_axis_route.dart';
import '../../widgets/mountain_image_widget.dart';
import 'shared_axis_detail_screen.dart';

class SharedAxisExploreScreen extends StatefulWidget {
  const SharedAxisExploreScreen({super.key});

  @override
  State<SharedAxisExploreScreen> createState() => _SharedAxisExploreScreenState();
}

class _SharedAxisExploreScreenState extends State<SharedAxisExploreScreen> {
  bool _isNavigating = false;

  void _openDetail({
    String mountainName = 'Mount Everest',
    String elevation = '8,848.86 m',
    String location = 'Nepal / Tibet',
    String subtitle = 'Highest mountain above sea level',
    String description =
        'Mount Everest is Earth\'s highest mountain above sea level, located in the Mahalangur Himal sub-range of the Himalayas. Its summit ridge marks the international border between Nepal and China (Tibet). First summited in 1953 by Sir Edmund Hillary and Tenzing Norgay.',
    String imageUrl =
        'https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=1200&auto=format&fit=crop',
  }) async {
    if (_isNavigating) return;
    _isNavigating = true;

    try {
      await Navigator.of(context).push(
        SharedAxisPageRoute(
          page: SharedAxisDetailScreen(
            mountainName: mountainName,
            elevation: elevation,
            location: location,
            subtitle: subtitle,
            description: description,
            imageUrl: imageUrl,
          ),
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
      body: SharedAxisPageWrapper(
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
                      onTap: () => _openDetail(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF18274B).withValues(alpha: 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Image Banner
                            SizedBox(
                              height: 190,
                              width: double.infinity,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  const MountainImageWidget(
                                    imageUrl:
                                        'https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=1200&auto=format&fit=crop',
                                    mountainName: 'Mount Everest',
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 14,
                                    left: 14,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'FEATURED PEAK',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.5,
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
                                        color: const Color(0xFF7C3AED),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        '8,848.86 m',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Card Information
                            Padding(
                              padding: const EdgeInsets.all(18),
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
                                            Text(
                                              'Mount Everest',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFF1E1B2E),
                                                letterSpacing: -0.3,
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  size: 14,
                                                  color: Color(0xFF64748B),
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Nepal / Tibet',
                                                  style: TextStyle(
                                                    fontSize: 12.5,
                                                    color: Color(0xFF64748B),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF3E8FF),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 18,
                                          color: Color(0xFF7C3AED),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Action Button (Explore Mountain)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => _openDetail(),
                        icon: const Text(
                          'Explore Mountain',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        label: const Icon(Icons.arrow_forward_rounded, size: 18),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Supporting Mountains Section Header
                    const Text(
                      'Other Eight-Thousanders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1B2E),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Supporting Entry 1: K2
                    _buildSupportingMountainTile(
                      name: 'K2',
                      elevation: '8,611 m',
                      range: 'Karakoram Range',
                      location: 'Pakistan / China',
                      imageUrl:
                          'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?q=80&w=1200&auto=format&fit=crop',
                      onTap: () => _openDetail(
                        mountainName: 'K2',
                        elevation: '8,611 m',
                        location: 'Pakistan / China',
                        subtitle: 'Second-highest peak on Earth',
                        description:
                            'K2 is the world\'s second-highest mountain at 8,611 metres, located on the China-Pakistan border in the Karakoram range. It is revered as the Savage Mountain due to its technical difficulty and high fatality rate.',
                        imageUrl:
                            'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?q=80&w=1200&auto=format&fit=crop',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Supporting Entry 2: Kangchenjunga
                    _buildSupportingMountainTile(
                      name: 'Kangchenjunga',
                      elevation: '8,586 m',
                      range: 'Himalaya Range',
                      location: 'Nepal / India',
                      imageUrl:
                          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1200&auto=format&fit=crop',
                      onTap: () => _openDetail(
                        mountainName: 'Kangchenjunga',
                        elevation: '8,586 m',
                        location: 'Nepal / India',
                        subtitle: 'Third-highest peak on Earth',
                        description:
                            'Kangchenjunga rises to 8,586 metres along the India-Nepal border. It comprises five distinct summits revered as sacred treasures of snow by indigenous local communities.',
                        imageUrl:
                            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1200&auto=format&fit=crop',
                      ),
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
    required String name,
    required String elevation,
    required String range,
    required String location,
    required String imageUrl,
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
                  imageUrl: imageUrl,
                  mountainName: name,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1B2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$elevation • $location',
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
