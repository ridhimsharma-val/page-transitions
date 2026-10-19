import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FlipMiniPreview extends StatefulWidget {
  const FlipMiniPreview({super.key});

  @override
  State<FlipMiniPreview> createState() => _FlipMiniPreviewState();
}

class _FlipMiniPreviewState extends State<FlipMiniPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
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
        // Flip between -0.4 and 0.4 radians (or 0 to 180 degrees)
        final angle = (t - 0.5) * math.pi;

        final isBack = angle.abs() > (math.pi / 2);

        final matrix = Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(angle);

        return Container(
          decoration: BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Transform(
              alignment: Alignment.center,
              transform: matrix,
              child: Container(
                width: 90,
                height: 60,
                decoration: BoxDecoration(
                  gradient: isBack
                      ? const LinearGradient(
                          colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                        ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: (isBack ? Colors.pink : Colors.cyan).withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(math.sin(angle) * 10, 6),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isBack ? Icons.view_in_ar : Icons.threed_rotation,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
