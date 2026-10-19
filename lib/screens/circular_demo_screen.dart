import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../transitions/circular_reveal_route.dart';
import '../widgets/demo_scaffold.dart';

class CircularDemoScreen extends StatefulWidget {
  const CircularDemoScreen({super.key});

  @override
  State<CircularDemoScreen> createState() => _CircularDemoScreenState();
}

class _CircularDemoScreenState extends State<CircularDemoScreen> {
  final GlobalKey _triggerButtonKey = GlobalKey();
  bool _isNavigating = false;

  void _triggerReveal([Offset? explicitOrigin]) async {
    if (_isNavigating) return;
    _isNavigating = true;

    Offset? origin = explicitOrigin;

    // If no explicit coordinate was passed, compute center of the trigger button
    if (origin == null && _triggerButtonKey.currentContext != null) {
      final renderBox =
          _triggerButtonKey.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        origin = Offset(
          position.dx + (renderBox.size.width / 2),
          position.dy + (renderBox.size.height / 2),
        );
      }
    }

    await Navigator.of(context).push(
      CircularRevealPageRoute(
        page: CircularDestinationScreen(originPoint: origin),
        origin: origin,
      ),
    );

    if (mounted) {
      _isNavigating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Circular Reveal',
      category: 'Radial Geometry & Clipping',
      description:
          'Unfolds destination content radially outward from the exact epicenter of interaction, generating a focused ripple of spatial awareness.',
      accentColor: AppColors.accentCyan,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Origin selector interactive map
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.radar, color: AppColors.accentCyan, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'INTERACTIVE APERTURE ORIGIN',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tap any beacon coordinate on the field below to launch the circular reveal from that exact location, or use the primary trigger below.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),

                // Interactive target surface
                LayoutBuilder(
                  builder: (context, constraints) {
                    final fieldWidth = constraints.maxWidth;
                    const fieldHeight = 180.0;

                    return GestureDetector(
                      onTapDown: (details) {
                        final box = context.findRenderObject() as RenderBox?;
                        if (box != null) {
                          final globalPos = box.localToGlobal(details.localPosition);
                          _triggerReveal(globalPos);
                        }
                      },
                      child: Container(
                        width: fieldWidth,
                        height: fieldHeight,
                        decoration: BoxDecoration(
                          color: AppColors.bgPrimary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.accentCyan.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Coordinate grid lines
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _GridLinesPainter(),
                              ),
                            ),
                            const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.touch_app,
                                      color: AppColors.accentCyan, size: 28),
                                  SizedBox(height: 8),
                                  Text(
                                    'TAP ANYWHERE ON THIS PAD',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                      color: AppColors.accentCyan,
                                    ),
                                  ),
                                  Text(
                                    'Reveal expands dynamically from touch coordinate',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Primary Epicenter Trigger Button
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: _triggerButtonKey,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 6,
                    shadowColor: AppColors.accentCyan.withOpacity(0.4),
                  ),
                  onPressed: () => _triggerReveal(),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_outlined, size: 22, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        'Launch Center Epicenter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
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
    );
  }
}

class _GridLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.borderSubtle.withOpacity(0.5)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CircularDestinationScreen extends StatelessWidget {
  final Offset? originPoint;

  const CircularDestinationScreen({super.key, this.originPoint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B19),
      body: Stack(
        children: [
          // Background ambient gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.4, -0.3),
                  radius: 1.3,
                  colors: [
                    Color(0xFF0C4A6E),
                    Color(0xFF082F49),
                    Color(0xFF030712),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.accentCyan.withOpacity(0.3),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accentCyan.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.accentCyan.withOpacity(0.4),
                              ),
                            ),
                            child: const Text(
                              'APERTURE UNLOCKED',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: AppColors.accentCyan,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Quantum Reactor Visual Graphic
                      Center(
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [
                                Color(0xFF38BDF8),
                                Color(0xFF0284C7),
                                Color(0xFF0C4A6E),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentCyan.withOpacity(0.5),
                                blurRadius: 40,
                                spreadRadius: 6,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.radar,
                              size: 72,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      const Center(
                        child: Text(
                          'Quantum Matrix Core',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.6,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Epicenter Radial Wave Propagation',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.accentCyan,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Diagnostics Breakdown Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accentCyan.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Clipping Geometry Mathematics',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'The CircularRevealClipper computes the maximum Euclidean distance from the origin coordinate (${originPoint?.dx.toStringAsFixed(1) ?? 'Center'}, ${originPoint?.dy.toStringAsFixed(1) ?? 'Center'}) to all 4 corners of the viewport: R_max = max(d_TL, d_TR, d_BL, d_BR). As animation progress sweeps from 0.0 to 1.0, the canvas clips an expanding oval with an active shockwave ring.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Action Button
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.accentCyan,
                                side: const BorderSide(color: AppColors.accentCyan),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(Icons.close),
                              label: const Text(
                                'Close Radial Aperture',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
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
    );
  }
}
