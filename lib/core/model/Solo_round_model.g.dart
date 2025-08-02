// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Solo_round_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoloRoundModelAdapter extends TypeAdapter<SoloRoundModel> {
  @override
  final int typeId = 12;

  @override
  SoloRoundModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoloRoundModel(
      name: fields[0] as String,
      points: (fields[1] as List).cast<int>(),
      roundName: fields[2] as String,
      lombaName: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SoloRoundModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.points)
      ..writeByte(2)
      ..write(obj.roundName)
      ..writeByte(3)
      ..write(obj.lombaName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoloRoundModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
