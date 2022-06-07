import "dart:typed_data";

import "package:hive/hive.dart";

part "sound.g.dart";

@HiveType(typeId: 1)
class Sound {
  
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  Uint8List? audioBytes;

  @HiveField(3)
  String? audioPath;

  @HiveField(4)
  Uint8List? imageBytes;

  @HiveField(5)
  int themeId;

  @HiveField(6)
  bool isAsset; 

  Sound({
    this.id,
    required this.name,
    this.audioBytes,
    this.audioPath,
    this.imageBytes,
    required this.themeId,
    required this.isAsset
  });
}