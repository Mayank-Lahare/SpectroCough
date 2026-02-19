class PredictionResult {
  final String disease;
  final double confidence;
  final String authenticity;
  final double fakeProbability;
  final Map<String, double> classProbabilities;
  final String disclaimer;

  const PredictionResult({
    required this.disease,
    required this.confidence,
    required this.authenticity,
    required this.fakeProbability,
    required this.classProbabilities,
    required this.disclaimer,
  });
}
