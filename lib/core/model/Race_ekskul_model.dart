// lib/core/model/race_ekskul_model.dart

import 'package:hive/hive.dart';

part 'Race_ekskul_model.g.dart';

@HiveType(typeId: 5)
class RaceEkskulModel extends HiveObject {
  @HiveField(0)
  String nameRace;

  @HiveField(1)
  String status;

  RaceEkskulModel({
    required this.nameRace,
    required this.status,
  });
}