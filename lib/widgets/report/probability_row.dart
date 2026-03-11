import 'package:flutter/material.dart';
import 'package:spectrocough/theme/app_colors.dart';

class ProbabilityRow extends StatelessWidget {

  final String label;
  final double value;
  final bool isTop;

  const ProbabilityRow({
    super.key,
    required this.label,
    required this.value,
    this.isTop = false,
  });

  @override
  Widget build(BuildContext context) {

    final color = isTop ? AppColors.primary : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              if (isTop)
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "TOP",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),

              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontWeight: isTop ? FontWeight.w600 : FontWeight.w400,
                    color: color,
                  ),
                ),
              ),

              Text(
                "${(value * 100).toStringAsFixed(2)}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 700),
            tween: Tween(begin: 0, end: value),
            builder: (context, val, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: val,
                  minHeight: isTop ? 8 : 6,
                  backgroundColor: AppColors.surface,
                  color: color,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}