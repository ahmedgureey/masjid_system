import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Subtle tiled 8-point star (khātam) pattern for hero cards, splash and
/// onboarding backgrounds. Lightweight vector drawing, cached by a
/// [RepaintBoundary]. Use only on dark-green backgrounds at low opacity
/// (design-system §2).
class IslamicPattern extends StatelessWidget {
  const IslamicPattern({
    super.key,
    this.color = Colors.white,
    this.opacity = 0.06,
    this.tileSize = 56,
  });

  final Color color;
  final double opacity;
  final double tileSize;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _StarPatternPainter(
            color: color.withValues(alpha: opacity),
            tileSize: tileSize,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _StarPatternPainter extends CustomPainter {
  _StarPatternPainter({required this.color, required this.tileSize});

  final Color color;
  final double tileSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final star = _starPath(tileSize * 0.36);
    for (var y = 0.0; y < size.height + tileSize; y += tileSize) {
      for (var x = 0.0; x < size.width + tileSize; x += tileSize) {
        canvas.save();
        canvas.translate(x, y);
        canvas.drawPath(star, paint);
        canvas.restore();
      }
    }
  }

  /// Two overlapping squares (one rotated 45°) form the 8-point star.
  Path _starPath(double radius) {
    final path = Path();
    for (final rotation in [0.0, math.pi / 4]) {
      for (var i = 0; i < 4; i++) {
        final angle = rotation + i * math.pi / 2 + math.pi / 4;
        final point = Offset(
          radius * math.cos(angle),
          radius * math.sin(angle),
        );
        i == 0
            ? path.moveTo(point.dx, point.dy)
            : path.lineTo(point.dx, point.dy);
      }
      path.close();
    }
    path.addOval(Rect.fromCircle(center: Offset.zero, radius: radius * 0.35));
    return path;
  }

  @override
  bool shouldRepaint(_StarPatternPainter old) =>
      old.color != color || old.tileSize != tileSize;
}
