// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Date_ekskul_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DateEkskulModelAdapter extends TypeAdapter<DateEkskulModel> {
  @override
  final int typeId = 3;

  @override
  DateEkskulModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DateEkskulModel(
      date: fields[0] as DateTime,
      ekskul: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DateEkskulModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.ekskul);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateEkskulModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
