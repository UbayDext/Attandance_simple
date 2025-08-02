// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
part 'Achivement_model.g.dart';

@HiveType(typeId: 11)
class AchivementModel extends HiveObject {
  @HiveField(0)
  String nameStudent;

  @HiveField(1)
  String kelas;

  @HiveField(2)
  String ekskul;

  @HiveField(3)
  String imagepath;

  AchivementModel({
    required this.nameStudent,
    required this.kelas,
    required this.ekskul,
    required this.imagepath,
  });
}
