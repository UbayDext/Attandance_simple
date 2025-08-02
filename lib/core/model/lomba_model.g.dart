// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lomba_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LombaModelAdapter extends TypeAdapter<LombaModel> {
  @override
  final int typeId = 2;

  @override
  LombaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LombaModel(
      name: fields[0] as String,
      status: fields[1] as String,
      ekskul: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LombaModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.ekskul);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LombaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
