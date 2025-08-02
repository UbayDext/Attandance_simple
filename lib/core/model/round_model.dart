// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
part 'round_model.g.dart';

@HiveType(typeId: 7)
class RoundModel extends HiveObject {
  @HiveField(0)
  String round;

  @HiveField(1)
  DateTime startRound;

  @HiveField(2)
  DateTime endRound;

  @HiveField(3)
  String statusRound;

  @HiveField(4)
  String raceName;

  RoundModel({
    required this.round,
    required this.startRound,
    required this.endRound,
    required this.statusRound,
    required this.raceName,
  });
}
