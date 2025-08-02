import 'package:hive/hive.dart';
part 'Ekskul_data_storange.g.dart';

@HiveType(typeId: 0)
class EkskulDataStorange extends HiveObject {
  @HiveField(0)
  String nama;

  @HiveField(1)
  String jumlah;

  @HiveField(2)
  String jenjang;

  EkskulDataStorange({required this.nama, required this.jumlah, required this.jenjang});
}
