// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Achivement_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AchivementModelAdapter extends TypeAdapter<AchivementModel> {
  @override
  final int typeId = 11;

  @override
  AchivementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AchivementModel(
      nameStudent: fields[0] as String,
      kelas: fields[1] as String,
      ekskul: fields[2] as String,
      imagepath: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AchivementModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nameStudent)
      ..writeByte(1)
      ..write(obj.kelas)
      ..writeByte(2)
      ..write(obj.ekskul)
      ..writeByte(3)
      ..write(obj.imagepath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchivementModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
