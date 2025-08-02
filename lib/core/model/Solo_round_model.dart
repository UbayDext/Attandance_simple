// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'Solo_round_model.g.dart';

@HiveType(typeId: 12)
class SoloRoundModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> points;

  @HiveField(2)
  String roundName;

  @HiveField(3)
  String lombaName;

  SoloRoundModel({
    required this.name,
    required this.points,
    required this.roundName,
    required this.lombaName,
  });
}
