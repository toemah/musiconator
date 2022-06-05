// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoundAdapter extends TypeAdapter<Sound> {
  @override
  final int typeId = 1;

  @override
  Sound read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sound(
      id: fields[0] as int?,
      name: fields[1] as String,
      audioBytes: fields[2] as Uint8List?,
      audioPath: fields[3] as String?,
      imageBytes: fields[4] as Uint8List?,
      themeId: fields[5] as int,
      isAsset: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Sound obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.audioBytes)
      ..writeByte(3)
      ..write(obj.audioPath)
      ..writeByte(4)
      ..write(obj.imageBytes)
      ..writeByte(5)
      ..write(obj.themeId)
      ..writeByte(6)
      ..write(obj.isAsset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoundAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
