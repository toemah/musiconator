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
    SoundTheme(id: -1, name: "explosion"),
    SoundTheme(id: -2, name: "fun"),
    SoundTheme(id: -3, name: "serious"),
  ];

  static List<Map<Object, Object>> defaultSounds = [
    {
      "themeId": -1,
      "sounds": [
        {"name": "default explosion", "asset": "explosion.mp3"}
      ]
    },
    {
      "themedId": -2,
      "sounds": [
        {"name": "flush", "asset": "flush.mp3"},
        {"name": "splat", "asset": "splat.mp3"}
      ]
    },
    {"themeId": -3, "sounds": []}
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ThemeScreen(themes: defaultThemes),
    );
  }
}
