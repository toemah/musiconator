import 'package:hive/hive.dart';

part 'sound.g.dart';

@HiveType(typeId: 1)
class Sound {
  
  @HiveField(0)
  String name;
  
  @HiveField(1)
  String? path;

  Sound({
    required this.name,
    required this.path,
  });
}