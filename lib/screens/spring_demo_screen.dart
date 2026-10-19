import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../transitions/spring_slide_route.dart';
import '../widgets/demo_scaffold.dart';

class SpringDemoScreen extends StatefulWidget {
  const SpringDemoScreen({super.key});

  @override
  State<SpringDemoScreen> createState() => _SpringDemoScreenState();
}

class _SpringDemoScreenState extends State<SpringDemoScreen> {
  AxisDirection _selectedDirection = AxisDirection.left;
  bool _isNavigating = false;

  void _triggerSpringTransition() async {
    if (_isNavigating) return;
    _isNavigating = true;

    await Navigator.of(context).push(
      SpringSlidePageRoute(
        page: SpringDestinationScreen(direction: _selectedDirection),
        direction: _selectedDirection,
      ),
    );

    if (mounted) {
      _isNavigating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Spring Slide + Fade',
      category: 'Inertia & Damped Oscillations',
      description:
          'Simulates real-world physical mass and damping coefficients. Combines horizontal translation with subtle depth scaling and smooth opacity transitions.',
      accentColor: AppColors.secondaryLavender,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Direction Selector
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
                    Icon(Icons.tune, color: AppColors.secondaryLavender, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'VECTOR TRAJECTORY DIRECTION',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildDirectionChip(
                      AxisDirection.left,
                      'Leftward (Standard)',
                      Icons.arrow_back,
                    ),
                    const SizedBox(width: 8),
                    _buildDirectionChip(
                      AxisDirection.right,
                      'Rightward',
                      Icons.arrow_forward,
                    ),
                    const SizedBox(width: 8),
                    _buildDirectionChip(
                      AxisDirection.up,
                      'Upward',
                      Icons.arrow_upward,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Physical Spring Simulation Visual Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Harmonic Damping Characteristics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tuned with damping ratio γ = 16.0 and angular stiffness k = 180.0. This eliminates unnatural bouncy wobble while delivering satisfying physical weight upon touchdown.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Visual physics parameter chips
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildParamPill('STIFFNESS', '180 N/m'),
                    _buildParamPill('DAMPING', '16.0 N·s/m'),
                    _buildParamPill('OVERSHOOT', '2.8% Snap'),
                    _buildParamPill('DURATION', '650ms'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Launch Action Button
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryViolet,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 6,
                  shadowColor: AppColors.primaryViolet.withOpacity(0.4),
                ),
                onPressed: _triggerSpringTransition,
                icon: const Icon(Icons.speed, size: 22),
                label: const Text(
                  'Launch Spring Slide Route',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildDirectionChip(AxisDirection direction, String title, IconData icon) {
    final isSelected = _selectedDirection == direction;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _selectedDirection = direction),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryViolet.withOpacity(0.2)
                : AppColors.bgPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryViolet : AppColors.borderSubtle,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.secondaryLavender : AppColors.textMuted,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParamPill(String key, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$key: ',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            val,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryLavender,
            ),
          ),
        ],
      ),
    );
  }
}

class SpringDestinationScreen extends StatelessWidget {
  final AxisDirection direction;

  const SpringDestinationScreen({super.key, required this.direction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11111B),
      appBar: AppBar(
        title: const Text('VELOCITY TELEMETRY'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF312E81),
                          Color(0xFF1E1B4B),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.primaryViolet.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.speed,
                          color: AppColors.secondaryLavender,
                          size: 38,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Spring Settling Complete',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Motion entered from vector ${direction.name.toUpperCase()} with 0.94 -> 1.0 depth scale coupling.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryLavender,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Diagnostics Cards
                  _buildDiagRow(
                    'Parallax Depth Secondary',
                    'As this incoming screen slid into focus, the previous route gracefully scaled back to 0.92 with a 25% negative translation, creating optical depth layering.',
                  ),
                  const SizedBox(height: 16),
                  _buildDiagRow(
                    'Harmonic Oscillation Equation',
                    'Calculated via: f(t) = 1.0 - e^(-γt) · (cos(ωt) + (γ/ω)sin(ωt)), producing immediate kinetic feedback followed by smooth settling.',
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryViolet,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text(
                        'Reverse Spring Slide',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiagRow(String title, String body) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
