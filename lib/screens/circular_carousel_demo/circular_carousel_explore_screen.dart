import 'package:flutter/material.dart';
import '../../models/mountain_data.dart';
import '../../transitions/circular_reveal_route.dart';
import '../../widgets/mountain_image_widget.dart';
import '../mountain_detail_screen.dart';

/// Screen A — Curved Circular Mountain Carousel for Design 05 with Infinite Looping.
///
/// Features:
/// 1. Bidirectional, continuous infinite looping via virtual modulo indexing.
/// 2. Curved interactive mountain carousel built with [PageView.builder] and [PageController].
/// 3. Cards follow a subtle curved arc (parabolic vertical drop of ~22px) with differential scaling and opacity.
/// 4. Continuous fractional interpolation on swipe without abrupt frame jumps or resets.
/// 5. Side-card tap selection with 400ms easeOutCubic animation.
/// 6. Expanding circular reveal transition to [MountainDetailScreen], originating
///    from the exact center of the active mountain card.
class CircularCarouselExploreScreen extends StatefulWidget {
  final int initialIndex;

  const CircularCarouselExploreScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<CircularCarouselExploreScreen> createState() =>
      _CircularCarouselExploreScreenState();
}

class _CircularCarouselExploreScreenState
    extends State<CircularCarouselExploreScreen> {
  // Generous base page allowing thousands of swipes in either direction immediately
  static const int _kInitialVirtualPage = 1000;

  final List<MountainData> _mountains = MountainData.all;
  late int _currentVirtualIndex;
  late final PageController _pageController;
  final Map<int, GlobalKey> _cardKeys = {};
  bool _isNavigating = false;

  int _realIndex(int virtualIndex) {
    if (_mountains.isEmpty) return 0;
    return (virtualIndex % _mountains.length + _mountains.length) % _mountains.length;
  }

  MountainData get activeMountain {
    if (_mountains.isEmpty) return MountainData.everest;
    return _mountains[_realIndex(_currentVirtualIndex)];
  }

  @override
  void initState() {
    super.initState();
    final initialMountainIndex =
        widget.initialIndex.clamp(0, _mountains.isEmpty ? 0 : _mountains.length - 1);

    if (_mountains.length > 1) {
      // Ensure base is an exact multiple of the mountain count
      final int alignedBase =
          (_kInitialVirtualPage ~/ _mountains.length) * _mountains.length;
      _currentVirtualIndex = alignedBase + initialMountainIndex;
    } else {
      _currentVirtualIndex = initialMountainIndex;
    }

    _pageController = PageController(
      viewportFraction: 0.72,
      initialPage: _currentVirtualIndex,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache mountain images to eliminate flashing during circular reveal
    for (final mountain in _mountains) {
      precacheImage(NetworkImage(mountain.imageUrl), context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Calculates the center of the active card in global coordinates.
  Offset _getActiveCardCenter() {
    final key = _cardKeys[_currentVirtualIndex];
    final renderBox = key?.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      return renderBox.localToGlobal(
        Offset(renderBox.size.width / 2, renderBox.size.height / 2),
      );
    }

    // Fallback: screen center
    final mediaQuery = MediaQuery.maybeOf(context);
    final size = mediaQuery?.size ?? const Size(390, 844);
    return Offset(size.width / 2, size.height * 0.45);
  }

  /// Opens the details screen for the selected mountain using CircularRevealPageRoute.
  void _openDetail(MountainData mountain, [Offset? explicitOrigin]) async {
    if (_isNavigating) return;
    _isNavigating = true;

    final revealOrigin = explicitOrigin ?? _getActiveCardCenter();

    try {
      await Navigator.of(context).push(
        CircularRevealPageRoute(
          page: MountainDetailScreen(
            mountain: mountain,
            isCircularReveal: true,
          ),
          origin: revealOrigin,
          transitionDurationOverride: const Duration(milliseconds: 650),
          reverseTransitionDurationOverride: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInOutCubic,
          showRing: false,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  void _onCardTap(int virtualIndex, [BuildContext? cardContext]) {
    if (virtualIndex == _currentVirtualIndex) {
      Offset? origin;
      if (cardContext != null) {
        final renderBox = cardContext.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          origin = renderBox.localToGlobal(
            Offset(renderBox.size.width / 2, renderBox.size.height / 2),
          );
        }
      }
      _openDetail(activeMountain, origin);
    } else {
      _pageController.animateToPage(
        virtualIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Navigation and Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
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
                      const SizedBox(width: 14),

                      // Header Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE9FE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'DESIGN 05 • CIRCULAR CAROUSEL',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                  color: Color(0xFF7C3AED),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Explore Peaks',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E1B2E),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle Instruction
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Swipe horizontally to navigate peaks continuously in either direction.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Curved Mountain Carousel
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double carouselHeight = constraints.maxHeight;
                      final double cardHeight = (carouselHeight * 0.88).clamp(280.0, 420.0);

                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, _) {
                          double page = _currentVirtualIndex.toDouble();
                          if (_pageController.hasClients &&
                              _pageController.position.haveDimensions) {
                            page = _pageController.page ?? _currentVirtualIndex.toDouble();
                          }

                          return PageView.builder(
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _mountains.length > 1 ? null : 1,
                            onPageChanged: (virtualIndex) {
                              setState(() {
                                _currentVirtualIndex = virtualIndex;
                                _cardKeys.removeWhere(
                                    (k, _) => (k - _currentVirtualIndex).abs() > 10);
                              });
                            },
                            itemBuilder: (context, virtualIndex) {
                              final realIndex = _realIndex(virtualIndex);
                              final mountain = _mountains[realIndex];
                              final double delta = page - virtualIndex;
                              final double absDelta = delta.abs();

                              // Scale: active card = 1.0, immediate neighbors = ~0.85
                              final double scale = (1.0 - (0.15 * absDelta)).clamp(0.76, 1.0);

                              // Curved vertical arc: center card = 0, side cards drop by 22px
                              final double verticalOffset = (22.0 *
                                      (absDelta <= 1.0
                                          ? absDelta * absDelta
                                          : (2.0 * absDelta - 1.0)))
                                  .clamp(0.0, 44.0);

                              // Opacity: center card = 1.0, side cards minimum ~0.70
                              final double opacity = (1.0 - (0.30 * absDelta)).clamp(0.70, 1.0);

                              final bool isSelected = virtualIndex == _currentVirtualIndex;
                              final key = _cardKeys.putIfAbsent(
                                  virtualIndex, () => GlobalKey());

                              return Center(
                                child: Transform.translate(
                                  offset: Offset(0, verticalOffset),
                                  child: Transform.scale(
                                    scale: scale,
                                    child: Opacity(
                                      opacity: opacity,
                                      child: SizedBox(
                                        key: key,
                                        height: cardHeight,
                                        child: _buildMountainCard(
                                          mountain: mountain,
                                          isSelected: isSelected,
                                          onTap: (cardCtx) =>
                                              _onCardTap(virtualIndex, cardCtx),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Selected Mountain Information & Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E1B2E).withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  Text(
                                    activeMountain.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1E1B2E),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE9FE),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      activeMountain.shortElevation,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF7C3AED),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${activeMountain.range} • ${activeMountain.location}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Action Button with Circular Reveal Trigger
                        Material(
                          color: const Color(0xFF7C3AED),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _openDetail(activeMountain),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 16,
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
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMountainCard({
    required MountainData mountain,
    required bool isSelected,
    required void Function(BuildContext context) onTap,
  }) {
    return Builder(
      builder: (cardContext) {
        return GestureDetector(
          onTap: () => onTap(cardContext),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFE2E8F0),
                width: isSelected ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? const Color(0xFF7C3AED).withValues(alpha: 0.16)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: isSelected ? 24 : 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Mountain Photograph
                MountainImageWidget(
                  imageUrl: mountain.imageUrl,
                  mountainName: mountain.name,
                  fit: BoxFit.cover,
                ),

                // Subtle atmospheric gradient overlay for readability
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // Top Badges
                Positioned(
                  top: 14,
                  left: 14,
                  right: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            mountain.mountainType.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          mountain.shortElevation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Mountain Label
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mountain.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFFCBD5E1),
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              mountain.shortLocation,
                              style: const TextStyle(
                                color: Color(0xFFE2E8F0),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
