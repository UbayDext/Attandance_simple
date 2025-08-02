// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Siswa_studi_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SiswaStudiModelAdapter extends TypeAdapter<SiswaStudiModel> {
  @override
  final int typeId = 1;

  @override
  SiswaStudiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SiswaStudiModel(
      nama: fields[0] as String,
      kelas: fields[1] as String,
      ekskul: fields[2] as String,
      jenjang: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SiswaStudiModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.kelas)
      ..writeByte(2)
      ..write(obj.ekskul)
      ..writeByte(3)
      ..write(obj.jenjang);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SiswaStudiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
