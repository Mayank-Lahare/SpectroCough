import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_drawer.dart';
import '../models/prediction_result.dart';

class ResultScreen extends StatefulWidget {
  final PredictionResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // ============================================================
  // Interpretation Helpers
  // ============================================================

  String _interpretConfidence(double confidence) {
    if (confidence >= 85) return "High confidence pattern match.";
    if (confidence >= 70) return "Moderate confidence pattern match.";
    if (confidence >= 50) return "Low confidence. Pattern overlap detected.";
    return "Inconclusive result. Consider retesting.";
  }

  double _computeTop2Margin(Map<String, dynamic> probabilities) {
    final values =
        probabilities.values.map((e) => (e as num).toDouble()).toList()
          ..sort((a, b) => b.compareTo(a));

    if (values.length < 2) return 0;
    return values[0] - values[1];
  }

  String _stabilityIndex(double margin) {
    if (margin >= 40) return "High Stability";
    if (margin >= 20) return "Moderate Stability";
    if (margin >= 10) return "Low Stability";
    return "Unstable Prediction";
  }

  Color _stabilityColor(double margin) {
    if (margin >= 40) return Colors.green;
    if (margin >= 20) return Colors.amber;
    if (margin >= 10) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final disease = widget.result.predictedDisease;
    final confidence = widget.result.confidence;
    final classProbabilities = widget.result.classProbabilities;

    final sortedEntries = classProbabilities.entries.toList()
      ..sort((a, b) => (b.value as num).compareTo(a.value as num));

    final top2Margin = widget.result.top2Margin != 0
        ? widget.result.top2Margin
        : _computeTop2Margin(classProbabilities);

    final warnings = widget.result.warnings;

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Result')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // ============================================================
              // Main Result Card
              // ============================================================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Predicted Condition',
                        style: AppTextStyles.smallText,
                      ),

                      const SizedBox(height: 4),

                      Text(disease, style: AppTextStyles.headingLarge),

                      const SizedBox(height: 8),

                      Text(
                        'Confidence: ${confidence.toStringAsFixed(2)}%',
                        style: AppTextStyles.bodyText,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _interpretConfidence(confidence),
                        style: AppTextStyles.smallText,
                      ),

                      const SizedBox(height: 12),

                      // ====================================================
                      // Stability Section
                      // ====================================================
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _stabilityColor(
                            top2Margin,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _stabilityIndex(top2Margin),
                              style: AppTextStyles.bodyText.copyWith(
                                color: _stabilityColor(top2Margin),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Top-2 Δ: ${top2Margin.toStringAsFixed(2)}%',
                              style: AppTextStyles.smallText,
                            ),
                          ],
                        ),
                      ),

                      // ====================================================
                      // Warning Section (If Any)
                      // ====================================================
                      if (warnings.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Model Advisory",
                                style: AppTextStyles.headingSmall,
                              ),
                              const SizedBox(height: 8),
                              ...warnings.map(
                                (warning) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.warning_amber_rounded,
                                        size: 18,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          warning,
                                          style: AppTextStyles.bodyText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ============================================================
              // Probability Bars Section
              // ============================================================
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Class Probability Distribution',
                          style: AppTextStyles.headingMedium,
                        ),

                        const SizedBox(height: 12),

                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: sortedEntries.map((entry) {
                              final value = (entry.value as num).toDouble();

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: AppTextStyles.bodyText,
                                        ),
                                        Text(
                                          '${value.toStringAsFixed(2)}%',
                                          style: AppTextStyles.bodyText,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    LinearProgressIndicator(
                                      value: value / 100,
                                      minHeight: 8,
                                      backgroundColor: Colors.grey.shade300,
                                      color: AppColors.buttonBlue,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ============================================================
              // Footer Button
              // ============================================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
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
