import 'package:flutter/material.dart';
import 'package:musiconator/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundWidget.dart';
import 'package:musiconator/soundtheme.dart';

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

  static List<Map<Object, Object>> defaultThemes = [
    {
      "name": "explosion",
      "sounds": [
        {"name": "default explosion", "asset": "explosion.mp3"}
      ]
    },
    {
      "name": "fun",
      "sounds": [
        {"name": "flush", "asset": "flush.mp3"},
        {"name": "splat", "asset": "splat.mp3"}
      ]
    },
    {"name": "serious", "sounds": []}
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(),
      ),
    );
  }
}
