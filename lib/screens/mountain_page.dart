import 'package:flutter/material.dart';
import '../models/mountain_data.dart';
import '../widgets/mountain_hero_shuttle.dart';
import '../widgets/mountain_image_widget.dart';
import 'mountain_detail_screen.dart';

class MountainPage extends StatefulWidget {
  const MountainPage({super.key});

  @override
  State<MountainPage> createState() => _MountainPageState();
}

class _MountainPageState extends State<MountainPage> {
  int _currentNavIndex = 0; // 0: Home, 1: Explore, 2: Saved, 3: Profile
  bool _isNavigating = false;

  final Set<String> _favoriteIds = {'everest'};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final mountain in MountainData.all) {
      precacheImage(NetworkImage(mountain.imageUrl), context);
    }
  }

  void _openDetail(MountainData mountain) async {
    if (_isNavigating) return;
    _isNavigating = true;

    try {
      final result = await Navigator.of(context).push<bool>(
        PageRouteBuilder(
          opaque: true,
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) {
            return MountainDetailScreen(
              mountain: mountain,
              initialFavorited: _favoriteIds.contains(mountain.id),
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        ),

      );

      if (result != null && mounted) {
        setState(() {
          if (result) {
            _favoriteIds.add(mountain.id);
          } else {
            _favoriteIds.remove(mountain.id);
          }
        });
      }
    } finally {
      if (mounted) {
        _isNavigating = false;
      }
    }
  }

  void _toggleFavorite(String mountainId) {
    setState(() {
      if (_favoriteIds.contains(mountainId)) {
        _favoriteIds.remove(mountainId);
      } else {
        _favoriteIds.add(mountainId);
      }
    });
  }

  List<MountainData> _getFilteredMountains() {
    if (_currentNavIndex == 2) {
      // Saved tab
      return MountainData.all.where((m) => _favoriteIds.contains(m.id)).toList();
    }
    return MountainData.all;
  }

  @override
  Widget build(BuildContext context) {
    final filteredMountains = _getFilteredMountains();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FC),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              children: [
                // Main Scrollable Area with Heading, Decorative Mountain Graphic & Mountain Grid
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),

                          // Header Text with Subtle Vector Mountain Silhouette
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                right: 0,
                                top: -10,
                                child: Opacity(
                                  opacity: 0.18,
                                  child: CustomPaint(
                                    size: const Size(160, 100),
                                    painter: _HeaderSilhouettePainter(),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'World Above',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E1B2E),
                                      letterSpacing: -0.8,
                                      height: 1.1,
                                    ),
                                  ),
                                  const Text(
                                    '8,000 Metres',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E1B2E),
                                      letterSpacing: -0.8,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Explore the highest peaks on Earth, one story at a time.',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFF64748B),
                                      height: 1.4,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: 32,
                                    height: 3.5,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7C3AED),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // 2-Column Mobile Grid of Mountain Cards
                          if (filteredMountains.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(32),
                              margin: const EdgeInsets.only(top: 24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.favorite_border_rounded,
                                    size: 40,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'No Saved Peaks Yet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E1B2E),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Tap the heart icon on any mountain to bookmark it.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredMountains.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.74,
                              ),
                              itemBuilder: (context, index) {
                                final mountain = filteredMountains[index];
                                final isFavorited = _favoriteIds.contains(mountain.id);

                                return _buildMountainCard(
                                  mountain: mountain,
                                  isFavorited: isFavorited,
                                );
                              },
                            ),

                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Navigation Bar (Home, Explore, Saved, Profile)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            index: 0,
                            icon: Icons.home_rounded,
                            label: 'Home',
                          ),
                          _buildNavItem(
                            index: 1,
                            icon: Icons.explore_outlined,
                            label: 'Explore',
                          ),
                          _buildNavItem(
                            index: 2,
                            icon: _favoriteIds.isNotEmpty
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            label: 'Saved',
                            badgeCount: _favoriteIds.length,
                          ),
                          _buildNavItem(
                            index: 3,
                            icon: Icons.person_outline_rounded,
                            label: 'Profile',
                          ),
                        ],
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
  }

  Widget _buildMountainCard({
    required MountainData mountain,
    required bool isFavorited,
  }) {
    return GestureDetector(
      onTap: () => _openDetail(mountain),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFEAEFF6), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF18274B).withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Container with Stable Hero Flight
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
              child: Stack(
                children: [
                  Hero(
                    tag: 'mountain-hero-image-${mountain.id}',
                    createRectTween: (begin, end) =>
                        SmoothHeroRectTween(begin: begin, end: end),
                    placeholderBuilder: (context, heroSize, child) {
                      return SizedBox.fromSize(size: heroSize);
                    },
                    flightShuttleBuilder: (
                      flightContext,
                      animation,
                      flightDirection,
                      fromHeroContext,
                      toHeroContext,
                    ) {
                      return MountainHeroFlightShuttle(
                        animation: animation,
                        flightDirection: flightDirection,
                        mountain: mountain,
                        sourceRadius: BorderRadius.circular(16),
                        destinationRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 126,
                        width: double.infinity,
                        child: MountainImageWidget(
                          imageUrl: mountain.imageUrl,
                          mountainName: mountain.name,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _toggleFavorite(mountain.id),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          size: 15,
                          color: isFavorited
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Metadata (Name, Elevation, Location, and Arrow Button)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mountain.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E1B2E),
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            mountain.shortElevation,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            mountain.shortLocation,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3E8FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    int badgeCount = 0,
  }) {
    final isSelected = _currentNavIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (index == 3) {
          _showProfileModal();
        } else {
          setState(() {
            _currentNavIndex = index;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? const Color(0xFF7C3AED)
                      : const Color(0xFF94A3B8),
                ),
                if (badgeCount > 0 && index == 2)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFF7C3AED),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3E8FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.terrain_rounded,
                      color: Color(0xFF7C3AED),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alpine Explorer Pass',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1B2E),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'High-Altitude Expedition Logbook',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFEDE9FE)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ProfileStat(label: 'Peaks Logged', val: '4 / 14'),
                    _ProfileStat(label: 'Highest Elevation', val: '8,848 m'),
                    _ProfileStat(label: 'Death Zone Pass', val: 'Active'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Available Eight-thousanders in this release: Mount Everest, K2, Kangchenjunga, and Lhotse. More peaks are being mapped.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close Logbook',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String val;

  const _ProfileStat({required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E1B2E),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _HeaderSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.9);
    path.lineTo(size.width * 0.35, size.height * 0.45);
    path.lineTo(size.width * 0.55, size.height * 0.65);
    path.lineTo(size.width * 0.82, size.height * 0.25);
    path.lineTo(size.width, size.height * 0.55);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
