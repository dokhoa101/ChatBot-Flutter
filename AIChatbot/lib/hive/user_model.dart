import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String image;

  UserModel({
    required this.name,
    required this.image,
  });
}
