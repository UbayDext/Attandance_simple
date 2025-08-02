// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Champion_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChampionModelAdapter extends TypeAdapter<ChampionModel> {
  @override
  final int typeId = 13;

  @override
  ChampionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChampionModel(
      fotoPath: fields[0] as String?,
      nama: fields[1] as String,
      jenjang: fields[2] as String,
      ekskul: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChampionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.fotoPath)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.jenjang)
      ..writeByte(3)
      ..write(obj.ekskul);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChampionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
