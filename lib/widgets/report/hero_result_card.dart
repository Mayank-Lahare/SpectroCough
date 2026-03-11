import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:spectrocough/models/detailed_report_model.dart';
import 'package:spectrocough/theme/app_colors.dart';

class HeroResultCard extends StatelessWidget {
  final DetailedReport report;

  const HeroResultCard({super.key, required this.report});

  Color _confidenceColor(double value) {
    if (value > 80) return AppColors.success;
    if (value > 50) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {

    final confColor = _confidenceColor(report.confidence);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [

          SizedBox(
            width: 90,
            height: 90,
            child: CustomPaint(
              painter: _ConfidenceArcPainter(
                value: report.confidence / 100,
                color: confColor,
              ),
              child: Center(
                child: Text(
                  "${report.confidence.toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  report.predictedClass.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "cough pattern detected",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfidenceArcPainter extends CustomPainter {

  final double value;
  final Color color;

  _ConfidenceArcPainter({
    required this.value,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * value.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ConfidenceArcPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}