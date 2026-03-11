import 'package:flutter/material.dart';
import 'package:spectrocough/theme/app_text_styles.dart';

class SectionCard extends StatelessWidget {

  final String title;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(title, style: AppTextStyles.headingMedium),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }
}