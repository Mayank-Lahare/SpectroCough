import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_drawer.dart';
import '../models/prediction_result.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  // TEMP: dummy data to design UI (replace with API result later)
  PredictionResult _dummyResult() {
    return const PredictionResult(
      disease: 'Asthma',
      confidence: 66.63,
      authenticity: 'Authentic Cough',
      fakeProbability: 1.92,
      classProbabilities: {
        'Asthma': 66.63,
        'Healthy': 23.49,
        'COPD': 8.70,
        'Pneumonia': 0.79,
        'Bronchial': 0.39,
      },
      disclaimer:
      'This is a pre-screening tool, not a medical diagnostic device. '
          'Consult a healthcare professional for accurate diagnosis.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _dummyResult();

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
                        result.disease,
                        style: AppTextStyles.headingLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Confidence: ${result.confidence.toStringAsFixed(2)}%',
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Authenticity: ${result.authenticity}',
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fake probability: ${result.fakeProbability.toStringAsFixed(2)}%',
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

              ...result.classProbabilities.entries.map(
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
                          '${entry.value.toStringAsFixed(2)}%',
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
              Text(
                result.disclaimer,
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
