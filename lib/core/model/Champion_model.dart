import 'package:hive/hive.dart';

part 'Champion_model.g.dart';

@HiveType(typeId: 13)
class ChampionModel extends HiveObject {
  @HiveField(0)
  String? fotoPath;

  @HiveField(1)
  String nama;

  @HiveField(2)
  String jenjang;

  @HiveField(3)
  String ekskul;

  ChampionModel({
    this.fotoPath,
    required this.nama,
    required this.jenjang,
    required this.ekskul,
  });
}
