import 'package:flutter/material.dart';
import 'package:musiconator/hiveutils.dart';
import 'package:musiconator/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundtheme.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SoundAdapter());
  Hive.registerAdapter(SoundThemeAdapter());
  await Hive.openBox<Sound>(MyApp.soundBox);
  await Hive.openBox<SoundTheme>(MyApp.soundThemeBox);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const double spacing = 10.0;
  static const double maxWidth = 500.0;
  static const double maxWidthLarge = 800.0;

  static const String title = "Musiconator";
  static const String soundBox = "sound";
  static const String soundThemeBox = "theme";

  static const String assetsPath = "assets/audio/";

  static List<SoundTheme> themes = [
    SoundTheme(id: 0, name: "explosion"),
    SoundTheme(id: 1, name: "fun"),
    SoundTheme(id: 2, name: "serious"),
  ];

  static List<Sound> sounds = [
    Sound(id: -1, name: "default explosion", path: "explosion.mp3", themeId: 0),
    Sound(id: -1, name: "flushing toilet", path: "flush.mp3", themeId: 1),
    Sound(id: -1, name: "goop sound", path: "splat.mp3", themeId: 1)
  ];

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    MyApp.themes.addAll(HiveUtils.soundThemeBox.values.toList().map((e) => e));
    MyApp.sounds.addAll(HiveUtils.soundBox.values.toList().map((e) => e));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp.title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.deepPurpleAccent,
          onPrimary: Colors.white,
          secondary: Colors.deepPurpleAccent,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.red.shade700,
          background: ThemeData.dark().scaffoldBackgroundColor,
          onBackground: ThemeData.dark().backgroundColor,
          surface: Colors.blueGrey,
          onSurface: Colors.white,
          
        ),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white
        )
      ),
      home: Homepage(themes: MyApp.themes),
    );
  }
}
