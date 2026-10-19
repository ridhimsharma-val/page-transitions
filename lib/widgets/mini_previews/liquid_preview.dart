import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LiquidMiniPreview extends StatefulWidget {
  const LiquidMiniPreview({super.key});

  @override
  State<LiquidMiniPreview> createState() => _LiquidMiniPreviewState();
}

class _LiquidMiniPreviewState extends State<LiquidMiniPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
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
              // Underneath surface
              Container(
                color: AppColors.bgPrimary,
                child: const Center(
                  child: Icon(
                    Icons.water_drop_outlined,
                    color: AppColors.textMuted,
                    size: 26,
                  ),
                ),
              ),
              // Fluid wave surface
              CustomPaint(
                size: Size.infinite,
                painter: _MiniLiquidWavePainter(progress: progress),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MiniLiquidWavePainter extends CustomPainter {
  final double progress;

  _MiniLiquidWavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final waveIntensity = math.sin(progress * math.pi);
    final baseX = size.width * (1.0 - progress);
    final amp = 18.0 * waveIntensity;
    final phase = progress * math.pi * 2.5;

    path.moveTo(size.width, 0);

    const int steps = 25;
    for (int i = 0; i <= steps; i++) {
      final y = size.height * (i / steps);
      final normalizedY = y / size.height;
      final x = (baseX - (amp * math.sin(normalizedY * 3 * math.pi + phase))).clamp(0.0, size.width);

      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF9B7BFF),
          Color(0xFF4F46E5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, fillPaint);

    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = const Color(0xFFC4B5FD).withOpacity(0.9);

    canvas.drawPath(path, edgePaint);
  }

  @override
  bool shouldRepaint(_MiniLiquidWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
