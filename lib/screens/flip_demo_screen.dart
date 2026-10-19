import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../transitions/flip_3d_route.dart';
import '../widgets/demo_scaffold.dart';

class FlipDemoScreen extends StatefulWidget {
  const FlipDemoScreen({super.key});

  @override
  State<FlipDemoScreen> createState() => _FlipDemoScreenState();
}

class _FlipDemoScreenState extends State<FlipDemoScreen> {
  FlipAxis _selectedAxis = FlipAxis.horizontal;
  bool _isNavigating = false;

  void _trigger3DFlip() async {
    if (_isNavigating) return;
    _isNavigating = true;

    await Navigator.of(context).push(
      Flip3DPageRoute(
        page: FlipDestinationScreen(axis: _selectedAxis),
        axis: _selectedAxis,
      ),
    );

    if (mounted) {
      _isNavigating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '3D Flip Perspective',
      category: 'Affine 3D Matrix Transforms',
      description:
          'Projects the viewport onto a virtual 3D camera plane with real perspective foreshortening and glancing shadow illumination during axial rotation.',
      accentColor: AppColors.accentPink,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Axis Toggle
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
                    Icon(Icons.threed_rotation, color: AppColors.accentPink, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'ROTATION AXIS ORIENTATION',
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
                    Expanded(
                      child: _buildAxisButton(
                        FlipAxis.horizontal,
                        'Y-Axis (Book Flip)',
                        Icons.swap_horiz,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAxisButton(
                        FlipAxis.vertical,
                        'X-Axis (Card Flip)',
                        Icons.swap_vert,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Perspective Mathematics Blueprint Card
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
                  'Homogeneous 4x4 Transformation Matrix',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Matrix entry (3, 2) is populated with 0.0014 to simulate camera depth focal length, eliminating 2D flat shearing and creating true Euclidean depth. The card scales backward along the Z-axis during transit.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.bgPrimary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Text(
                    'Matrix4.identity()..setEntry(3, 2, 0.0014)..rotateY(θ)',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: AppColors.accentPink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Trigger Button
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 6,
                    shadowColor: AppColors.accentPink.withOpacity(0.4),
                  ),
                  onPressed: _trigger3DFlip,
                  icon: const Icon(Icons.flip, size: 22),
                  label: const Text(
                    'Rotate 3D Viewport',
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

  Widget _buildAxisButton(FlipAxis axis, String label, IconData icon) {
    final isSelected = _selectedAxis == axis;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _selectedAxis = axis),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentPink.withOpacity(0.2)
              : AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.accentPink : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.accentPink : AppColors.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlipDestinationScreen extends StatelessWidget {
  final FlipAxis axis;

  const FlipDestinationScreen({super.key, required this.axis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140C1A),
      appBar: AppBar(
        title: const Text('DIMENSIONAL VAULT'),
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
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF831843),
                          Color(0xFF4C0519),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.accentPink.withOpacity(0.4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentPink.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.view_in_ar,
                          size: 64,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Reverse Face Rendered',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Transformed around the ${axis.name.toUpperCase()} axis with perspective lighting simulation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.pink.shade100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lighting Falloff Simulation',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'In physical space, surfaces turning obliquely to the camera lose reflected luminance. Our custom route applies a dynamic dark mask that peaks at 90° azimuth and lifts back to zero as the front face snaps forward.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(
                      'Flip Back to Origin',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
