// ============================================================
// Prediction Result Model (Backend DTO)
// ------------------------------------------------------------
// Represents prediction response returned from backend
//  Hive Removed. Pure data model.
// ============================================================

class PredictionResult {
  final String predictedDisease;
  final double confidence;
  final double top2Margin;
  final Map<String, dynamic> classProbabilities;
  final List<String> warnings;

  PredictionResult({
    required this.predictedDisease,
    required this.confidence,
    required this.top2Margin,
    required this.classProbabilities,
    required this.warnings,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictedDisease: json['predicted_disease'] ?? 'Unknown',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      top2Margin: (json['top2_margin'] as num?)?.toDouble() ?? 0,
      classProbabilities: Map<String, dynamic>.from(
        json['class_probabilities'] ?? {},
      ),
      warnings:
          (json['warnings'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
