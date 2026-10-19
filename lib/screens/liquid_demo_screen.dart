import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../transitions/liquid_swipe_route.dart';
import '../widgets/demo_scaffold.dart';

class LiquidDemoScreen extends StatefulWidget {
  const LiquidDemoScreen({super.key});

  @override
  State<LiquidDemoScreen> createState() => _LiquidDemoScreenState();
}

class _LiquidDemoScreenState extends State<LiquidDemoScreen> {
  bool _isNavigating = false;

  void _triggerLiquidSwipe() async {
    if (_isNavigating) return;
    _isNavigating = true;

    await Navigator.of(context).push(
      LiquidSwipePageRoute(
        page: const LiquidDestinationScreen(),
      ),
    );

    if (mounted) {
      _isNavigating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Liquid Swipe Wave',
      category: 'Non-Linear Harmonic Morphing',
      description:
          'Sweeps across the viewport with a fluid sinusoidal wave boundary. The wave envelope expands organically in mid-flight and settles cleanly.',
      accentColor: AppColors.accentEmerald,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wave dynamics blueprint
          Container(
            padding: const EdgeInsets.all(22),
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
                    Icon(Icons.waves, color: AppColors.accentEmerald, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'FLUID WAVE HYDRODYNAMICS',
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
                  'The sweep boundary is computed across 40 continuous Bezier slices modulated by dual harmonic sine waves: A1·sin(2.5πy + φ) + A2·cos(4πy + 1.5φ). The amplitude is modulated by sin(π·t) so that edges remain perfectly flat at rest and dynamically turbulent in motion.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),

                // Fluid properties
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPill('PRIMARY AMP', '80px swell'),
                    _buildPill('HARMONIC', 'Dual sinusoidal'),
                    _buildPill('CREST', 'Glowing neon blur'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Fluid Visual Trigger Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF064E3B),
                  Color(0xFF022C22),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accentEmerald.withOpacity(0.3),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.water, color: AppColors.accentEmerald, size: 32),
                SizedBox(height: 12),
                Text(
                  'Viscosity Wave Sweep',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Watch the neon crest illuminate as the wave sweeps right to left.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFA7F3D0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Launch Action
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentEmerald,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 6,
                    shadowColor: AppColors.accentEmerald.withOpacity(0.4),
                  ),
                  onPressed: _triggerLiquidSwipe,
                  icon: const Icon(Icons.waves, size: 22, color: Colors.black),
                  label: const Text(
                    'Trigger Liquid Wave Sweep',
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

  Widget _buildPill(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.accentEmerald,
            ),
          ),
        ],
      ),
    );
  }
}

class LiquidDestinationScreen extends StatelessWidget {
  const LiquidDestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF031A14),
      appBar: AppBar(
        title: const Text('HYDRODYNAMIC LAB'),
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
                      gradient: const RadialGradient(
                        center: Alignment(0.2, -0.2),
                        radius: 1.2,
                        colors: [
                          Color(0xFF059669),
                          Color(0xFF064E3B),
                          Color(0xFF022C22),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentEmerald.withOpacity(0.3),
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.water_drop,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Fluid Surface Settled',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sinusoidal wave displacement returned to zero amplitude at boundary.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFA7F3D0),
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
                          'Dynamic Fluid Boundary Mathematics',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Rather than a simple linear slide or mask, the LiquidWaveClipper evaluates an organic wave envelope where x(y, t) dynamically oscillates with frequency harmonics while moving horizontally. The luminous edge path is painted simultaneously with a dual-layer blurred glow.',
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
                      backgroundColor: AppColors.accentEmerald,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(
                      'Reverse Liquid Wave',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
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
