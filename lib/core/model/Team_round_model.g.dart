// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Team_round_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamRoundModelAdapter extends TypeAdapter<TeamRoundModel> {
  @override
  final int typeId = 10;

  @override
  TeamRoundModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamRoundModel(
      nameGroup: fields[0] as String,
      nameTeam1: fields[1] as String,
      nameTeam2: fields[2] as String,
      nameTeam3: fields[3] as String,
      nameTeam4: fields[4] as String,
      champion: fields[5] as String,
      nameLomba: fields[6] as String,
      nameEkskul: fields[7] as String,
      round1Status: (fields[8] as List?)?.cast<String?>(),
      round2Status: (fields[9] as List?)?.cast<String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, TeamRoundModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.nameGroup)
      ..writeByte(1)
      ..write(obj.nameTeam1)
      ..writeByte(2)
      ..write(obj.nameTeam2)
      ..writeByte(3)
      ..write(obj.nameTeam3)
      ..writeByte(4)
      ..write(obj.nameTeam4)
      ..writeByte(5)
      ..write(obj.champion)
      ..writeByte(6)
      ..write(obj.nameLomba)
      ..writeByte(7)
      ..write(obj.nameEkskul)
      ..writeByte(8)
      ..write(obj.round1Status)
      ..writeByte(9)
      ..write(obj.round2Status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamRoundModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
