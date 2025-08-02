import 'package:hive_flutter/hive_flutter.dart';

// TAMBAHKAN BARIS INI
part 'Date_ekskul_model.g.dart';

@HiveType(typeId: 3)
class DateEkskulModel extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String ekskul;

  DateEkskulModel({
    required this.date,
    required this.ekskul,});
}
