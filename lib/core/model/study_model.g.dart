// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyModelAdapter extends TypeAdapter<StudyModel> {
  @override
  final int typeId = 6;

  @override
  StudyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyModel(
      nameStudi: fields[0] as String,
      jumlah: fields[1] as String,
      jenjang: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudyModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nameStudi)
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
      other is StudyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
