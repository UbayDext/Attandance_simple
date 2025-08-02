// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Ekskul_data_storange.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EkskulDataStorangeAdapter extends TypeAdapter<EkskulDataStorange> {
  @override
  final int typeId = 0;

  @override
  EkskulDataStorange read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EkskulDataStorange(
      nama: fields[0] as String,
      jumlah: fields[1] as String,
      jenjang: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EkskulDataStorange obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.jumlah)
      ..writeByte(2)
      ..write(obj.jenjang);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EkskulDataStorangeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
