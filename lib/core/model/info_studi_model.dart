import 'package:hive/hive.dart';
part 'info_studi_model.g.dart';
@HiveType(typeId: 8)
class InfoStudiModel extends HiveObject {
  @HiveField(0)
  String nameInfoStudi;

  InfoStudiModel({required this.nameInfoStudi});
}
