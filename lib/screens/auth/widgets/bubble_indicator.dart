// ============================================================
// Bubble Indicator Painter
// ------------------------------------------------------------
// Smooth pill-shaped page indicator that slides between tabs.
// Renders a drop-shadow + filled pill that tracks PageController.
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';

class BubbleIndicatorPainter extends CustomPainter {
  BubbleIndicatorPainter({
    required this.pageController,
    required this.color,
    this.dxTarget = 125,
    this.dxEntry = 25,
    this.radius = 20,
    this.dy = 24,
  }) : super(repaint: pageController);

  final PageController pageController;
  final Color color;

  final double dxTarget;
  final double dxEntry;
  final double radius;
  final double dy;

  @override
  void paint(Canvas canvas, Size size) {
    if (!pageController.hasClients) return;

    final position = pageController.position;

    final fullExtent =
        position.maxScrollExtent -
        position.minScrollExtent +
        position.viewportDimension;

    final pageOffset = position.extentBefore / fullExtent;

    final bool leftToRight = dxEntry < dxTarget;
    final Offset entry = Offset(leftToRight ? dxEntry : dxTarget, dy);
    final Offset target = Offset(leftToRight ? dxTarget : dxEntry, dy);

    final Path path = Path();
    path.addArc(Rect.fromCircle(center: entry, radius: radius), 0.5 * pi, pi);
    path.addRect(Rect.fromLTRB(entry.dx, dy - radius, target.dx, dy + radius));
    path.addArc(Rect.fromCircle(center: target, radius: radius), 1.5 * pi, pi);

    canvas.translate(size.width * pageOffset, 0);

    // Soft shadow
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.18), 6, true);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BubbleIndicatorPainter oldDelegate) => true;
}
