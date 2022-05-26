import 'package:flutter/material.dart';
import 'package:musiconator/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundWidget.dart';
import 'package:musiconator/soundtheme.dart';
import 'package:musiconator/themescreen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SoundAdapter());
  Hive.registerAdapter(SoundThemeAdapter());
  await Hive.openBox<Sound>(MyApp.soundBox);
  await Hive.openBox<SoundTheme>(MyApp.soundThemeBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String title = "Musiconator";
  static const String soundBox = "sound";
  static const String soundThemeBox = "theme";

  static const String assetsPath = "assets/audio/";

  static List<SoundTheme> defaultThemes = [
    SoundTheme(id: 0, name: "explosion"),
    SoundTheme(id: 1, name: "fun"),
    SoundTheme(id: 2, name: "serious"),
  ];

  static List<Sound> defaultsSounds = [
    Sound(
      id: -1, 
      name: "default explosion", 
      path: "explosion.mp3", 
      themeId: 0
    ),
    Sound(
      id: -1, 
      name: "flushing toilet", 
      path: "flush.mp3", 
      themeId: 1
    ),
    Sound(
      id: -1,
      name: "goop sound",
      path: "splat.mp3",
      themeId: 1
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(),
    );
  }
}
