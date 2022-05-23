import 'package:hive_flutter/hive_flutter.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundtheme.dart';

class HiveUtils {
  static Box<Sound> soundBox = Hive.box(MyApp.soundBox);
  static Box<SoundTheme> soundThemeBox = Hive.box(MyApp.soundThemeBox);

  static addSound(String name, String path, String? imagePath, int themeId) {
    soundBox.add(Sound(
        id: soundBox.length,
        name: name,
        path: path,
        imagePath: imagePath,
        themeId: themeId));
  }

  static updateSound(
      int id, String? name, String? path, String? imagePath, int? themeId) {
    Sound? oldSound = soundBox.getAt(id);
    if (oldSound != null) {
      soundBox.putAt(
        id,
        Sound(
            id: id,
            name: name ?? oldSound.name,
            path: path ?? oldSound.path,
            imagePath: imagePath ?? oldSound.imagePath,
            themeId: themeId ?? oldSound.themeId),
      );
    }
  }

  static deleteSound(int id) {
    if (soundBox.getAt(id) != null) soundBox.deleteAt(id);
  }

  static addTheme(String name) {
    soundThemeBox.add(SoundTheme(
      id: soundThemeBox.length,
      name: name,
    ));
  }

  static updateTheme(int id, String name) {
    SoundTheme? oldTheme = soundThemeBox.getAt(id);
    if (oldTheme != null) {
      soundThemeBox.putAt(
          id,
          SoundTheme(
            id: id,
            name: name,
          ));
    }
  }

  static deleteTheme(int id) {
    if (soundThemeBox.getAt(id) != null) soundThemeBox.deleteAt(id);
  }
}
