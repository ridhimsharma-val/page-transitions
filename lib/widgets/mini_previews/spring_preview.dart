import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../transitions/spring_slide_route.dart';

class SpringMiniPreview extends StatefulWidget {
  const SpringMiniPreview({super.key});

  @override
  State<SpringMiniPreview> createState() => _SpringMiniPreviewState();
}

class _SpringMiniPreviewState extends State<SpringMiniPreview>
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
      curve: const DampedSpringCurve(damping: 14.0, stiffness: 150.0),
      reverseCurve: Curves.easeInOutCubic,
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
        final t = _animation.value;

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: AppColors.bgPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Physics grid lines
                CustomPaint(
                  size: Size.infinite,
                  painter: _SpringGridPainter(),
                ),
                // Outgoing screen ghost moving left with parallax
                Transform.translate(
                  offset: Offset(-t * 35, 0),
                  child: Opacity(
                    opacity: (1.0 - t * 0.7).clamp(0.0, 1.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 50,
                        height: 55,
                        decoration: BoxDecoration(
                          color: AppColors.bgElevated,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: const Icon(Icons.layers_outlined, size: 20, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                ),
                // Incoming spring card snapping into place
                Transform.translate(
                  offset: Offset((1.0 - t) * 110, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 80,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3B82F6),
                            Color(0xFF8B5CF6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.speed,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
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

class _SpringGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.borderSubtle.withOpacity(0.4)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 16) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
