// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Trofi_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrofiModelAdapter extends TypeAdapter<TrofiModel> {
  @override
  final int typeId = 9;

  @override
  TrofiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrofiModel(
      lomba: fields[0] as String,
      filePath: fields[1] as String,
      ekskul: fields[2] as String,
      nameSiswa: fields[3] as String,
      kelas: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrofiModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.lomba)
      ..writeByte(1)
      ..write(obj.filePath)
      ..writeByte(2)
      ..write(obj.ekskul)
      ..writeByte(3)
      ..write(obj.nameSiswa)
      ..writeByte(4)
      ..write(obj.kelas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrofiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
