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
      id: fields[0] as int,
      name: fields[1] as String,
      path: fields[2] as String,
      imagePath: fields[3] as String,
      themeId: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Sound obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.themeId);
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
