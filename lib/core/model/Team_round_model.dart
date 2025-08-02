import 'package:hive/hive.dart';

part 'Team_round_model.g.dart';

@HiveType(typeId: 10)
class TeamRoundModel extends HiveObject {
  @HiveField(0)
  String nameGroup;

  @HiveField(1)
  String nameTeam1;
  @HiveField(2)
  String nameTeam2;
  @HiveField(3)
  String nameTeam3;
  @HiveField(4)
  String nameTeam4;
  @HiveField(5)
  String champion;

  @HiveField(6)
  String nameLomba;
  @HiveField(7)
  String nameEkskul;

  @HiveField(8)
  List<String?>? round1Status;
  @HiveField(9)
  List<String?>? round2Status;

  TeamRoundModel({
    required this.nameGroup,
    required this.nameTeam1,
    required this.nameTeam2,
    required this.nameTeam3,
    required this.nameTeam4,
    required this.champion,
    required this.nameLomba,
    required this.nameEkskul,
    this.round1Status,
    this.round2Status,
  });
}
