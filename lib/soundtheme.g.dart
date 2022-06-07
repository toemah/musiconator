// GENERATED CODE - DO NOT MODIFY BY HAND

part of "soundtheme.dart";

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoundThemeAdapter extends TypeAdapter<SoundTheme> {
  @override
  final int typeId = 2;

  @override
  SoundTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoundTheme(
      id: fields[0] as int,
      name: fields[1] as String,
      isDefault: fields[2] as bool,
      hide: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SoundTheme obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isDefault)
      ..writeByte(3)
      ..write(obj.hide);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoundThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
