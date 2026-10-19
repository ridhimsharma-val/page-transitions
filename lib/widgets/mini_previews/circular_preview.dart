import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CircularMiniPreview extends StatefulWidget {
  const CircularMiniPreview({super.key});

  @override
  State<CircularMiniPreview> createState() => _CircularMiniPreviewState();
}

class _CircularMiniPreviewState extends State<CircularMiniPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final progress = _animation.value;

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Underneath screen preview
              Container(
                color: AppColors.bgPrimary,
                child: Center(
                  child: Icon(
                    Icons.fingerprint,
                    color: AppColors.textMuted.withOpacity(0.4),
                    size: 32,
                  ),
                ),
              ),
              // Circular clipped overlay
              CustomPaint(
                painter: _MiniCircularClipperPainter(progress: progress),
                size: Size.infinite,
              ),
              // Origin beacon indicator
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan.withOpacity(0.8),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
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

class _MiniCircularClipperPainter extends CustomPainter {
  final double progress;

  _MiniCircularClipperPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final origin = Offset(size.width - 23, size.height - 23);
    final maxDist = (origin - Offset.zero).distance;
    final currentRadius = maxDist * progress;

    final path = Path()..addOval(Rect.fromCircle(center: origin, radius: currentRadius));

    // Fill with gradient destination
    final fillPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (origin.dx / size.width) * 2 - 1,
          (origin.dy / size.height) * 2 - 1,
        ),
        radius: 1.2,
        colors: const [
          Color(0xFF2E1065),
          Color(0xFF0F172A),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, fillPaint);

    // Dynamic wave ripples
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = const Color(0xFF38BDF8).withOpacity((1.0 - progress).clamp(0.0, 1.0));

    canvas.drawCircle(origin, currentRadius, ringPaint);
  }

  @override
  bool shouldRepaint(_MiniCircularClipperPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
