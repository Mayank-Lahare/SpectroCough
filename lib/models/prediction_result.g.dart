// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PredictionResultsAdapter extends TypeAdapter<PredictionResults> {
  @override
  final int typeId = 0;

  @override
  PredictionResults read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PredictionResults(
      condition: fields[0] as String,
      confidence: fields[1] as double,
      dateTime: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PredictionResults obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.condition)
      ..writeByte(1)
      ..write(obj.confidence)
      ..writeByte(2)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredictionResultsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
