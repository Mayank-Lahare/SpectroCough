import 'package:hive/hive.dart';

part 'prediction_result.g.dart';

@HiveType(typeId: 0)
class PredictionResults extends HiveObject {

  @HiveField(0)
  final String condition;

  @HiveField(1)
  final double confidence;

  @HiveField(2)
  final DateTime dateTime;

  PredictionResults({
    required this.condition,
    required this.confidence,
    required this.dateTime,
  });
}