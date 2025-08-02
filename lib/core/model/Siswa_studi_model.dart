// lib/models/siswa_model.dart

import 'package:hive/hive.dart';

part 'Siswa_studi_model.g.dart';

@HiveType(typeId: 1)
class SiswaStudiModel extends HiveObject {
  @HiveField(0)
  String nama;

  @HiveField(1)
  String kelas;

  @HiveField(2)
  String ekskul;

  @HiveField(3)
  String jenjang;

  SiswaStudiModel({
    required this.nama,
    required this.kelas,
    required this.ekskul,
    required this.jenjang,
  });
}
