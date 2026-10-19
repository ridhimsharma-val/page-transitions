import 'package:flutter/material.dart';

class MountainImageWidget extends StatelessWidget {
  final String imageUrl;
  final String mountainName;
  final BoxFit fit;

  const MountainImageWidget({
    super.key,
    required this.imageUrl,
    required this.mountainName,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return Container(
          color: const Color(0xFFEAEFF6),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingPlaceholder(loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackCanvas();
      },
    );
  }

  Widget _buildLoadingPlaceholder(ImageChunkEvent progress) {
    final expectedTotalBytes = progress.expectedTotalBytes;
    final loadedBytes = progress.cumulativeBytesLoaded;
    final percentage = expectedTotalBytes != null && expectedTotalBytes > 0
        ? (loadedBytes / expectedTotalBytes).clamp(0.0, 1.0)
        : null;

    return Container(
      color: const Color(0xFFEAEFF6),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            value: percentage,
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation<Color>(
              const Color(0xFF7C3AED).withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackCanvas() {
    return CustomPaint(
      painter: _MountainCanvasPainter(mountainName: mountainName),
      size: Size.infinite,
    );
  }
}

class _MountainCanvasPainter extends CustomPainter {
  final String mountainName;

  _MountainCanvasPainter({required this.mountainName});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Soft Alpine Sky Gradient (Neutral pastel tones, never red)
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE0E7FF),
          Color(0xFFEDE9FE),
          Color(0xFFF1F5F9),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    // 2. Distant Soft Mountain Ridge
    final distantRidge = Path();
    distantRidge.moveTo(0, size.height * 0.72);
    distantRidge.lineTo(size.width * 0.25, size.height * 0.44);
    distantRidge.lineTo(size.width * 0.52, size.height * 0.56);
    distantRidge.lineTo(size.width * 0.76, size.height * 0.40);
    distantRidge.lineTo(size.width, size.height * 0.68);
    distantRidge.lineTo(size.width, size.height);
    distantRidge.lineTo(0, size.height);
    distantRidge.close();

    final distantPaint = Paint()..color = const Color(0xFFC7D2FE).withValues(alpha: 0.7);
    canvas.drawPath(distantRidge, distantPaint);

    // 3. Main Central Summit Peak (Everest / K2 Pyramid Profile)
    final mainPeak = Path();
    mainPeak.moveTo(size.width * 0.08, size.height);
    mainPeak.lineTo(size.width * 0.48, size.height * 0.26);
    mainPeak.lineTo(size.width * 0.92, size.height);
    mainPeak.close();

    final peakPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF4338CA),
          Color(0xFF1E1B4B),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(mainPeak, peakPaint);

    // 4. Glacial Snow Cap & Ridge Highlights
    final snowCap = Path();
    snowCap.moveTo(size.width * 0.48, size.height * 0.26);
    snowCap.lineTo(size.width * 0.42, size.height * 0.42);
    snowCap.lineTo(size.width * 0.48, size.height * 0.38);
    snowCap.lineTo(size.width * 0.55, size.height * 0.46);
    snowCap.lineTo(size.width * 0.48, size.height * 0.26);
    snowCap.close();

    final snowPaint = Paint()..color = Colors.white.withValues(alpha: 0.95);
    canvas.drawPath(snowCap, snowPaint);

    // 5. Fore-ridge shadow side
    final shadowRidge = Path();
    shadowRidge.moveTo(size.width * 0.48, size.height * 0.26);
    shadowRidge.lineTo(size.width * 0.92, size.height);
    shadowRidge.lineTo(size.width * 0.48, size.height);
    shadowRidge.close();

    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.18);
    canvas.drawPath(shadowRidge, shadowPaint);
  }

  @override
  bool shouldRepaint(_MountainCanvasPainter oldDelegate) {
    return oldDelegate.mountainName != mountainName;
  }
}
