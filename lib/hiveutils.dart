import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundtheme.dart';

class HiveUtils {
  static Box<Sound> soundBox = Hive.box(MyApp.soundBox);
  static Box<SoundTheme> soundThemeBox = Hive.box(MyApp.soundThemeBox);

  static addSound({
    required String name,
    Uint8List? audioBytes,
    String? audioPath,
    Uint8List? imageBytes,
    required int themeId,
    required bool isAsset,
  }) {
    soundBox.add(
      Sound(
        id: soundBox.length,
        name: name,
        audioBytes: audioBytes,
        audioPath: audioPath,
        imageBytes: imageBytes,
        themeId: themeId,
        isAsset: isAsset,
      ),
    );
  }

  static updateSound({
    required int id,
    String? name,
    Uint8List? audioBytes,
    String? audioPath,
    Uint8List? imageBytes,
    int? themeId,
    bool? isAsset,
  }) {
    Sound? oldSound = soundBox.getAt(id);
    if (oldSound != null) {
      soundBox.putAt(
        id,
        Sound(
          id: id,
          name: name ?? oldSound.name,
          audioBytes: audioBytes ?? oldSound.audioBytes,
          audioPath: audioPath ?? oldSound.audioPath,
          imageBytes: imageBytes ?? oldSound.imageBytes,
          themeId: themeId ?? oldSound.themeId,
          isAsset: isAsset ?? oldSound.isAsset,
        ),
      );
    }
  }

  static deleteSound(int id) {
    if (soundBox.getAt(id) != null) {
      soundBox.deleteAt(id);
      if (id + 1 < soundBox.length) {
        for (var i = id + 1; i < soundBox.length; i++) {
          Sound sound = soundBox.getAt(i)!;
          soundBox.putAt(
            i,
            Sound(
              id: sound.id! - 1,
              name: sound.name,
              audioBytes: sound.audioBytes,
              audioPath: sound.audioPath,
              imageBytes: sound.imageBytes,
              themeId: sound.themeId,
              isAsset: sound.isAsset,
            ),
          );
        }
      }
    }
  }

  static addTheme({
    required String name,
    required bool isDefault,
    required bool hide,
  }) {
    soundThemeBox.add(SoundTheme(
      id: soundThemeBox.length,
      name: name,
      isDefault: isDefault,
      hide: hide,
    ));
  }

  static updateTheme({
    required int id,
    required String name,
    bool? isDefault,
    bool? hide,
  }) {
    SoundTheme? oldTheme = soundThemeBox.getAt(id);
    if (oldTheme != null) {
      soundThemeBox.putAt(
        id,
        SoundTheme(
          id: id,
          name: name,
          isDefault: isDefault ?? oldTheme.isDefault,
          hide: hide ?? oldTheme.hide,
        ),
      );
    }
  }

  static deleteTheme(int id) {
    if (soundThemeBox.getAt(id) != null) {
      if (id + 1 < soundThemeBox.length) {
        for (var i = id + 1; i < soundThemeBox.length; i++) {
          SoundTheme theme = soundThemeBox.getAt(i)!;
          soundThemeBox.putAt(
            i,
            SoundTheme(
              id: theme.id - 1,
              name: theme.name,
              isDefault: theme.isDefault,
              hide: theme.hide,
            ),
          );
        }
      }
      soundThemeBox.deleteAt(id);
    }
  }
}
