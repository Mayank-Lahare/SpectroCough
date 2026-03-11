class DetailedReport {
  final DateTime date;
  final String predictedClass;
  final double confidence;
  final Map<String, double> probabilities;

  DetailedReport({
    required this.date,
    required this.predictedClass,
    required this.confidence,
    required this.probabilities,
  });

  factory DetailedReport.fromJson(Map<String, dynamic> json) {
    return DetailedReport(
      date: DateTime.parse(json["created_at"]),
      predictedClass: json["predicted_class"],
      confidence: (json["confidence"] as num).toDouble(),
      probabilities: Map<String, double>.from(
        json["class_probabilities"],
      ),
    );
  }
}