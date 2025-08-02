import 'package:hive/hive.dart';
part 'attandence_ekskul_model.g.dart'; 
@HiveType(typeId: 4)
class AttandenceEkskulModel extends HiveObject {
  @HiveField(0)
  int idStudet;

  @HiveField(1)
  String ekskul;

  @HiveField(2)
  DateTime dateEkskul;

  @HiveField(3)
  String status;

  AttandenceEkskulModel({
    required this.idStudet,
    required this.ekskul,
    required this.dateEkskul,
    required this.status,
  });
}
