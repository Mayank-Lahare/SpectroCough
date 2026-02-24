import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prediction_result.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class HistoryDetailScreen extends StatelessWidget {
  final PredictionResults item;

  const HistoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'dd MMM yyyy | hh:mm a',
    ).format(item.dateTime);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Result Detail')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.condition, style: AppTextStyles.headingLarge),
                const SizedBox(height: 16),
                Text(
                  'Confidence: ${item.confidence.toStringAsFixed(2)}%',
                  style: AppTextStyles.bodyText,
                ),
                const SizedBox(height: 8),
                Text(formattedDate, style: AppTextStyles.smallText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
