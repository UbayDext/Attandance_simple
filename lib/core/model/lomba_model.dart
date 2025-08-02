import 'package:hive/hive.dart';
part 'lomba_model.g.dart'; // File ini akan di-generate

@HiveType(typeId: 2)
class LombaModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String status;

  @HiveField(2)
  String ekskul;

  LombaModel({required this.name, required this.status, required this.ekskul});
}
