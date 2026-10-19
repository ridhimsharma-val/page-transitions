import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DemoScaffold extends StatelessWidget {
  final String title;
  final String category;
  final String description;
  final Color accentColor;
  final Widget body;
  final VoidCallback? onReplay;
  final List<Widget>? actions;

  const DemoScaffold({
    super.key,
    required this.title,
    required this.category,
    required this.description,
    required this.accentColor,
    required this.body,
    this.onReplay,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          category.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w700,
            color: accentColor,
          ),
        ),
        actions: [
          if (onReplay != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                tooltip: 'Replay Transition',
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Icon(
                    Icons.replay,
                    size: 18,
                    color: AppColors.secondaryLavender,
                  ),
                ),
                onPressed: onReplay,
              ),
            ),
          ...?actions,
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Screen Content
                  body,
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
