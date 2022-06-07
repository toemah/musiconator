import "package:hive/hive.dart";

part "soundtheme.g.dart";

@HiveType(typeId: 2)
class SoundTheme {
  
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool isDefault;

  @HiveField(3)
  bool hide;

  SoundTheme({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.hide
  });
}