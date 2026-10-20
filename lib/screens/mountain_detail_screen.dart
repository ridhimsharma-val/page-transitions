import 'package:flutter/material.dart';
import '../models/mountain_data.dart';
import '../widgets/mountain_hero_shuttle.dart';
import '../widgets/mountain_image_widget.dart';

class MountainDetailScreen extends StatefulWidget {
  final MountainData mountain;
  final bool initialFavorited;

  const MountainDetailScreen({
    super.key,
    required this.mountain,
    this.initialFavorited = false,
  });

  @override
  State<MountainDetailScreen> createState() => _MountainDetailScreenState();
}

class _MountainDetailScreenState extends State<MountainDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fallbackController;

  late Animation<double> _sheetOpacity;
  late Animation<Offset> _sheetSlide;

  // Stagger 1: Mountain title
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

  // Stagger 2: Elevation & location
  late Animation<double> _metaOpacity;
  late Animation<Offset> _metaSlide;

  // Stagger 3: Short description
  late Animation<double> _descOpacity;
  late Animation<Offset> _descSlide;

  // Controls & overlays
  late Animation<double> _controlsOpacity;
  late Animation<double> _controlsScale;
  late Animation<double> _gradientOpacity;

  late bool _isFavorited;
  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.initialFavorited;

    _fallbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      value: 1.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_animationsInitialized) {
      final route = ModalRoute.of(context);
      final parentAnimation = route?.animation ?? _fallbackController;
      _setupAnimations(parentAnimation);
      _animationsInitialized = true;
    }
  }

  void _setupAnimations(Animation<double> parent) {
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (disableAnimations) {
      _sheetOpacity = const AlwaysStoppedAnimation(1.0);
      _sheetSlide = const AlwaysStoppedAnimation(Offset.zero);
      _titleOpacity = const AlwaysStoppedAnimation(1.0);
      _titleSlide = const AlwaysStoppedAnimation(Offset.zero);
      _metaOpacity = const AlwaysStoppedAnimation(1.0);
      _metaSlide = const AlwaysStoppedAnimation(Offset.zero);
      _descOpacity = const AlwaysStoppedAnimation(1.0);
      _descSlide = const AlwaysStoppedAnimation(Offset.zero);
      _controlsOpacity = const AlwaysStoppedAnimation(1.0);
      _controlsScale = const AlwaysStoppedAnimation(1.0);
      _gradientOpacity = const AlwaysStoppedAnimation(1.0);
      return;
    }

    // Content Sheet Container: smooth unified lift tracked with hero flight
    _sheetOpacity = CurvedAnimation(
      parent: parent,
      curve: const Interval(0.15, 0.90, curve: Curves.easeOutCubic),
      reverseCurve: const Interval(0.0, 0.60, curve: Curves.easeInCubic),
    );
    _sheetSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: parent,
      curve: const Interval(0.10, 1.0, curve: Curves.easeInOutCubicEmphasized),
      reverseCurve: Curves.easeInCubic,
    ));

    _titleOpacity = const AlwaysStoppedAnimation(1.0);
    _titleSlide = const AlwaysStoppedAnimation(Offset.zero);
    _metaOpacity = const AlwaysStoppedAnimation(1.0);
    _metaSlide = const AlwaysStoppedAnimation(Offset.zero);
    _descOpacity = const AlwaysStoppedAnimation(1.0);
    _descSlide = const AlwaysStoppedAnimation(Offset.zero);

    // Top Controls: Fade and scale gently as image settles
    _controlsOpacity = CurvedAnimation(
      parent: parent,
      curve: const Interval(0.35, 0.95, curve: Curves.easeOutCubic),
      reverseCurve: const Interval(0.0, 0.45, curve: Curves.easeInCubic),
    );
    _controlsScale = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: parent,
      curve: const Interval(0.35, 0.95, curve: Curves.easeOutBack),
      reverseCurve: const Interval(0.0, 0.45, curve: Curves.easeInCubic),
    ));

    _gradientOpacity = const AlwaysStoppedAnimation(1.0);
  }

  @override
  void dispose() {
    _fallbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mountain = widget.mountain;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F6FC),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // 1. Large Hero Mountain Photograph at Top
                      // Uses SmoothHeroRectTween & MountainHeroFlightShuttle for cinematic continuity
                      SizedBox(
                        height: 380,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
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
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(28),
                                  bottomRight: Radius.circular(28),
                                ),
                                child: SizedBox(
                                  height: 380,
                                  width: double.infinity,
                                  child: MountainImageWidget(
                                    imageUrl: mountain.imageUrl,
                                    mountainName: mountain.name,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            // Subtle bottom gradient overlay for photographic contrast
                            Positioned.fill(
                              child: FadeTransition(
                                opacity: _gradientOpacity,
                                child: IgnorePointer(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(28),
                                        bottomRight: Radius.circular(28),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.35),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.4],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 2. Coordinated Staggered Content Sheet
                      FadeTransition(
                        opacity: _sheetOpacity,
                        child: SlideTransition(
                          position: _sheetSlide,
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight: (MediaQuery.sizeOf(context).height - 350)
                                  .clamp(0.0, double.infinity),
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 24,
                                  offset: Offset(0, -6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Row: Title & Location on left, Elevation Badge on right
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Stagger 1: Mountain Title
                                          FadeTransition(
                                            opacity: _titleOpacity,
                                            child: SlideTransition(
                                              position: _titleSlide,
                                              child: Text(
                                                mountain.name,
                                                style: const TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color(0xFF1E1B2E),
                                                  letterSpacing: -0.6,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),

                                          // Stagger 2A: Location Subtitle
                                          FadeTransition(
                                            opacity: _metaOpacity,
                                            child: SlideTransition(
                                              position: _metaSlide,
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    size: 16,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      mountain.shortLocation,
                                                      style: const TextStyle(
                                                        fontSize: 13.5,
                                                        color: Color(0xFF64748B),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Stagger 2B: Elevation Badge
                                    FadeTransition(
                                      opacity: _metaOpacity,
                                      child: SlideTransition(
                                        position: _metaSlide,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              mountain.shortElevation,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF7C3AED),
                                                letterSpacing: -0.4,
                                              ),
                                            ),
                                            const Text(
                                              'Elevation',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF94A3B8),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 22),

                                  // Stagger 3: Concise Factual Description
                                  FadeTransition(
                                    opacity: _descOpacity,
                                    child: SlideTransition(
                                      position: _descSlide,
                                      child: Text(
                                        mountain.description,
                                        style: const TextStyle(
                                          fontSize: 14.5,
                                          color: Color(0xFF475569),
                                          height: 1.65,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),



                // 3. Floating Top Controls: Circular Back Button & Favorite Heart Control
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: FadeTransition(
                      opacity: _controlsOpacity,
                      child: ScaleTransition(
                        scale: _controlsScale,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Circular Back Button with comfortable 44x44 touch target
                            InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => Navigator.of(context).pop(_isFavorited),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                  color: Color(0xFF1E1B2E),
                                ),
                              ),
                            ),

                            // Circular Favorite Heart Control with comfortable 44x44 touch target
                            InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                setState(() {
                                  _isFavorited = !_isFavorited;
                                });
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                                  size: 22,
                                  color: _isFavorited
                                      ? const Color(0xFF7C3AED)
                                      : const Color(0xFF1E1B2E),
                                ),
                              ),
                            ),
                          ],
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
  }
}
