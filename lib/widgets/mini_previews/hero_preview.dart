import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HeroMiniPreview extends StatefulWidget {
  const HeroMiniPreview({super.key});

  @override
  State<HeroMiniPreview> createState() => _HeroMiniPreviewState();
}

class _HeroMiniPreviewState extends State<HeroMiniPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
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
        final t = _animation.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Background subtle grid
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgPrimary.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle.withOpacity(0.5)),
              ),
            ),
            // Origin card ghost frame
            Positioned(
              left: 18,
              top: 18,
              width: 44,
              height: 44,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primaryViolet.withOpacity(0.3),
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Destination card ghost frame
            Positioned(
              right: 18,
              bottom: 18,
              width: 90,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.secondaryLavender.withOpacity(0.3),
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Connecting motion flight curve (dotted path effect)
            Positioned(
              left: 18 + (t * 70),
              top: 18 + (t * 26),
              width: 44 + (t * 46),
              height: 44 + (t * 16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(const Color(0xFF818CF8), const Color(0xFFC084FC), t)!,
                      Color.lerp(const Color(0xFFC084FC), const Color(0xFFF472B6), t)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10 + (t * 2)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryViolet.withOpacity(0.35 + (t * 0.25)),
                      blurRadius: 12 + (t * 8),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 16 + (t * 6),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
