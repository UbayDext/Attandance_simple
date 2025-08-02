// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Race_ekskul_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RaceEkskulModelAdapter extends TypeAdapter<RaceEkskulModel> {
  @override
  final int typeId = 5;

  @override
  RaceEkskulModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RaceEkskulModel(
      nameRace: fields[0] as String,
      status: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RaceEkskulModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.nameRace)
      ..writeByte(1)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RaceEkskulModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
