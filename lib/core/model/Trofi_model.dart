import 'package:hive/hive.dart';

part 'Trofi_model.g.dart';

@HiveType(typeId: 9)
class TrofiModel extends HiveObject {
  @HiveField(0)
  String lomba;
  @HiveField(1)
  String filePath;
  @HiveField(2)
  String ekskul;
  @HiveField(3)
  String nameSiswa;
  @HiveField(4)
  String kelas;

  TrofiModel({
    required this.lomba,
    required this.filePath,
    required this.ekskul,
    required this.nameSiswa,
    required this.kelas,
  });
}
