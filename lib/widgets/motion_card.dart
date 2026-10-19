import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MotionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String tag;
  final Color accentColor;
  final Widget preview;
  final VoidCallback onTap;

  const MotionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.accentColor,
    required this.preview,
    required this.onTap,
  });

  @override
  State<MotionCard> createState() => _MotionCardState();
}

class _MotionCardState extends State<MotionCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.bgCardHover : AppColors.bgCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _isHovered
                    ? widget.accentColor.withOpacity(0.55)
                    : AppColors.borderSubtle,
                width: _isHovered ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? widget.accentColor.withOpacity(0.18)
                      : Colors.black.withOpacity(0.3),
                  blurRadius: _isHovered ? 24 : 12,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag & Launch Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.accentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.tag.toUpperCase(),
                        style: TextStyle(
                          color: widget.accentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isHovered
                            ? widget.accentColor
                            : AppColors.bgElevated,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: _isHovered ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Visual Motion Preview Box
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: widget.preview,
                  ),
                ),
                const SizedBox(height: 16),

                // Card Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle / Description
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Bottom affordance
                Row(
                  children: [
                    Text(
                      'Launch Demo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: widget.accentColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 14,
                      color: widget.accentColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
