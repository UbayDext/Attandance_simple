// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoundModelAdapter extends TypeAdapter<RoundModel> {
  @override
  final int typeId = 7;

  @override
  RoundModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoundModel(
      round: fields[0] as String,
      startRound: fields[1] as DateTime,
      endRound: fields[2] as DateTime,
      statusRound: fields[3] as String,
      raceName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RoundModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.round)
      ..writeByte(1)
      ..write(obj.startRound)
      ..writeByte(2)
      ..write(obj.endRound)
      ..writeByte(3)
      ..write(obj.statusRound)
      ..writeByte(4)
      ..write(obj.raceName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoundModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
