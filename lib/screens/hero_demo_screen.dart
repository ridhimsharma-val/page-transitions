import 'package:flutter/material.dart';

class HeroDemoScreen extends StatefulWidget {
  const HeroDemoScreen({super.key});

  @override
  State<HeroDemoScreen> createState() => _HeroDemoScreenState();
}

class _HeroDemoScreenState extends State<HeroDemoScreen> {
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

  void _openMountainDetail(BuildContext context) async {
    if (_isNavigating) return;
    _isNavigating = true;

    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const MountainDetailScreen(
            imageUrl: _everestImageUrl,
            title: 'Mount Everest',
            elevation: '8,848.86 m',
            range: 'Mahalangur Himal • Nepal / Tibet',
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

  @override
  Widget build(BuildContext context) {
    // Mobile-first container: On wide screens, center with mobile phone proportions
    return Scaffold(
      backgroundColor: const Color(0xFFF2F1F8),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                // Compact Top Bar with Back Arrow and Lab Exit
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: Color(0xFF1E1B2E),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.terrain, size: 14, color: Color(0xFF9333EA)),
                            SizedBox(width: 6),
                            Text(
                              'HERO TRANSITION',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                                color: Color(0xFF9333EA),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 38), // Balance spacing
                    ],
                  ),
                ),

                // Compact Pill / Filter Selector (Exact match to reference style)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E5F2),
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
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.06),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              _filters[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFFE11D48)
                                    : const Color(0xFF6B6882),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // Main Mobile Scroll Area
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Title: World Above 8,000 Metres
                        const Text(
                          'World Above\n8,000 Metres',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1B2E),
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
                            color: Color(0xFF6B6882),
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Featured Mountain Card with Hero Image
                        GestureDetector(
                          onTap: () => _openMountainDetail(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9333EA).withValues(alpha: 0.08),
                                  blurRadius: 28,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // The Hero Image
                                Hero(
                                  tag: 'featured-mountain-image',
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 270,
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
                                      // Top Altitude Pill Badge
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
                                      // Bottom gradient for text legibility
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        height: 60,
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
                                          const Column(
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
                                                      color: Color(0xFF1E1B2E),
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
                                                  color: Color(0xFF6B6882),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF3E8FF),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: const Color(0xFFD8B4FE),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              size: 18,
                                              color: Color(0xFF9333EA),
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
                                          color: const Color(0xFFFAF9FD),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: const Color(0xFFEBE7F5),
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.touch_app_outlined,
                                              size: 15,
                                              color: Color(0xFF9333EA),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Tap to trigger shared-element Hero transition',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF6B6882),
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

                        // Secondary Mountain Explorer Row
                        const Text(
                          'OTHER NOTABLE GIANTS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: Color(0xFF8B879E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSecondaryPeakCard(
                                name: 'K2 (Godwin-Austen)',
                                elevation: '8,611 m',
                                range: 'Karakoram',
                                iconColor: const Color(0xFF0284C7),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSecondaryPeakCard(
                                name: 'Kangchenjunga',
                                elevation: '8,586 m',
                                range: 'Eastern Himalaya',
                                iconColor: const Color(0xFFE11D48),
                              ),
                            ),
                          ],
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
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.terrain_outlined, size: 18, color: iconColor),
              Text(
                elevation,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1B2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1B2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            range,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8B879E),
            ),
          ),
        ],
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
            Color(0xFF6366F1),
            Color(0xFF3B82F6),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.terrain, size: 64, color: Colors.white70),
      ),
    );
  }
}

class MountainDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String elevation;
  final String range;

  const MountainDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.elevation,
    required this.range,
  });

  @override
  State<MountainDetailScreen> createState() => _MountainDetailScreenState();
}

class _MountainDetailScreenState extends State<MountainDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F1F8),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded Mountain Hero Image
                    Hero(
                      tag: 'featured-mountain-image',
                      child: Container(
                        height: 380,
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(36),
                            bottomRight: Radius.circular(36),
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF6366F1), Color(0xFF0F172A)],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.terrain, size: 72, color: Colors.white70),
                                  ),
                                );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.65),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.55],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              right: 20,
                              bottom: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Text(
                                      widget.elevation,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Hero(
                                    tag: 'featured-mountain-title',
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        widget.title,
                                        style: const TextStyle(
                                          fontSize: 34,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: -1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.range,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Staggered Mountain Exploration Content
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fast Statistics Chips
                              Row(
                                children: [
                                  _buildStatPill('FIRST ASCENT', '1953', 'Hillary & Norgay'),
                                  const SizedBox(width: 10),
                                  _buildStatPill('DEATH ZONE', '> 8,000 m', 'Low Oxygen'),
                                  const SizedBox(width: 10),
                                  _buildStatPill('BASE CAMP', '5,364 m', 'South Side'),
                                ],
                              ),
                              const SizedBox(height: 24),

                              const Text(
                                'About Mount Everest',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E1B2E),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Mount Everest, known in Nepali as Sagarmatha and in Tibetan as Chomolungma, is Earth\'s highest mountain above sea level. Located in the Mahalangur Himal sub-range of the Himalayas, its summit point lies on the international border between Nepal and the Tibet Autonomous Region of China.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B6882),
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Hero Transition Details Card
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.auto_awesome, color: Color(0xFF9333EA), size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          'Hero Flight Verification',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1E1B2E),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'The Everest image maintains continuous physical presence during the transition. Tap "Reverse Transition" below or swipe back to observe the shared element returning to the card.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B6882),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Bottom Reverse Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E1B2E),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 2,
                                  ),
                                  icon: const Icon(Icons.arrow_back, size: 18),
                                  label: const Text(
                                    'Reverse Transition',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Floating Back Button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Color(0xFF1E1B2E),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String title, String val, String sub) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9333EA),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              val,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B2E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF8B879E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
