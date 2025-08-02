// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attandence_ekskul_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttandenceEkskulModelAdapter extends TypeAdapter<AttandenceEkskulModel> {
  @override
  final int typeId = 4;

  @override
  AttandenceEkskulModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttandenceEkskulModel(
      idStudet: fields[0] as int,
      ekskul: fields[1] as String,
      dateEkskul: fields[2] as DateTime,
      status: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AttandenceEkskulModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.idStudet)
      ..writeByte(1)
      ..write(obj.ekskul)
      ..writeByte(2)
      ..write(obj.dateEkskul)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttandenceEkskulModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
