// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_studi_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfoStudiModelAdapter extends TypeAdapter<InfoStudiModel> {
  @override
  final int typeId = 8;

  @override
  InfoStudiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InfoStudiModel(
      nameInfoStudi: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InfoStudiModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.nameInfoStudi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoStudiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
