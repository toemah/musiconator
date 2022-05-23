import 'package:hive/hive.dart';

part 'sound.g.dart';

@HiveType(typeId: 1)
class Sound {
  
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String path;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  int themeId; 

  Sound({
    required this.id,
    required this.name,
    required this.path,
    required this.imagePath,
    required this.themeId
  });
}