import 'package:flutter/material.dart';

import '../../../../../core/resources/color_manager.dart';

/// Illustrated stand-in for the snapshot (Figma: "Image placeholder" —
/// night sky with stars, porch and a door with a knob). Drawn
/// proportionally so it scales to any frame size.
class SnapshotPlaceholder extends StatelessWidget {
  const SnapshotPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(painter: _DoorScenePainter(), child: SizedBox.expand());
  }
}

class _DoorScenePainter extends CustomPainter {
  const _DoorScenePainter();

  // Reference frame from Figma: 330 × 418 (image placeholder).
  static const double _w = 330;
  static const double _h = 418;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / _w;
    final sy = size.height / _h;
    Rect r(double x, double y, double w, double h) =>
        Rect.fromLTWH(x * sx, y * sy, w * sx, h * sy);

    // Background.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorManager.surfaceLight, ColorManager.surface],
        ).createShader(Offset.zero & size),
    );

    // Stars.
    final star = Paint()
      ..color = ColorManager.pureWhite.withValues(alpha: 0.5);
    const stars = [
      Offset(26, 56),
      Offset(88, 70),
      Offset(150, 56),
      Offset(212, 70),
      Offset(274, 56),
    ];
    for (final s in stars) {
      canvas.drawCircle(Offset(s.dx * sx, s.dy * sy), 2 * sx, star);
    }

    // Porch / wall.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        r(34, 274, 262, 150),
        topLeft: Radius.circular(12 * sx),
        topRight: Radius.circular(12 * sx),
      ),
      Paint()..color = ColorManager.homeBackground.withValues(alpha: 0.55),
    );

    // Door.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        r(110, 194, 110, 180),
        topLeft: Radius.circular(10 * sx),
        topRight: Radius.circular(10 * sx),
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorManager.orange.withValues(alpha: 0.45),
            ColorManager.orange.withValues(alpha: 0.15),
          ],
        ).createShader(r(110, 194, 110, 180)),
    );

    // Knob.
    canvas.drawCircle(
      Offset(206 * sx, 279 * sy),
      5 * sx,
      Paint()..color = ColorManager.orange,
    );
  }

  @override
  bool shouldRepaint(covariant _DoorScenePainter oldDelegate) => false;
}
