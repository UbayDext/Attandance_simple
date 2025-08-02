import 'package:hive/hive.dart';
part 'study_model.g.dart';

@HiveType(typeId: 6)
class StudyModel extends HiveObject {
  @HiveField(0)
  String nameStudi;
  
  @HiveField(1)
  String jumlah;
  
  @HiveField(2)
  String jenjang; 
  
  StudyModel({
    required this.nameStudi,
    required this.jumlah,
    required this.jenjang,
  });
}
