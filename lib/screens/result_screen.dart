import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_drawer.dart';
import '../models/prediction_result.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> resultData;

  const ResultScreen({super.key, required this.resultData});

  // TEMP: dummy data to design UI (replace with API result later)

  @override
  Widget build(BuildContext context) {
    final disease = resultData['predicted_disease'];
    final confidence = resultData['confidence'];
    final authenticity = resultData['authenticity'];
    final fakeProbability = resultData['fake_probability'];
    final classProbabilities = Map<String, dynamic>.from(
      resultData['class_probabilities'],
    );

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Result')),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // MAIN RESULT CARD
              // =========================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Predicted Condition',
                        style: AppTextStyles.smallText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        disease ?? 'Unknown',
                        style: AppTextStyles.headingLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Confidence: ${(confidence ?? 0).toStringAsFixed(2)}%',
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Authenticity: ${authenticity ?? 'Unknown'}',
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fake probability: ${(fakeProbability ?? 0).toStringAsFixed(2)}%',
                        style: AppTextStyles.smallText,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // =========================
              // CLASS PROBABILITIES
              // =========================
              const Text(
                'All Class Probabilities',
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: 12),

              ...classProbabilities.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(entry.key, style: AppTextStyles.bodyText),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${(entry.value as num).toStringAsFixed(2)}%',
                          textAlign: TextAlign.right,
                          style: AppTextStyles.bodyText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // =========================
              // DISCLAIMER
              // =========================
              const Text(
                'This is a pre-screening tool, not a medical diagnostic device. '
                'Consult a healthcare professional for accurate diagnosis.',
                style: AppTextStyles.smallText,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // =========================
              // ACTION BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Screen Another',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
