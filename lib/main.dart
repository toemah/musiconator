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

  static List<SoundTheme> defaultThemes = [
    SoundTheme(id: 0, name: "Explosion", isDefault: true, hide: false),
    SoundTheme(id: 1, name: "Fun", isDefault: true, hide: false),
    SoundTheme(id: 2, name: "Serious", isDefault: true, hide: false),
  ];

  static List<Sound> defaultSounds = [
    Sound(
        isAsset: true,
        name: "Explosion sympa",
        audioPath: "explosion.mp3",
        themeId: 0),
    Sound(
      isAsset: true,
      name: "Chasse d'eau",
      audioPath: "flush.mp3",
      themeId: 1,
    ),
    Sound(
      isAsset: true,
      name: "Splash",
      audioPath: "splat.mp3",
      themeId: 1,
    ),
  ];

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    if (HiveUtils.soundThemeBox.length < MyApp.defaultThemes.length) {
      for (SoundTheme theme in MyApp.defaultThemes) {
        HiveUtils.addTheme(name: theme.name, isDefault: theme.isDefault, hide: theme.hide);
        for (Sound sound in MyApp.defaultSounds.where((e) => e.themeId == theme.id)) {
          HiveUtils.addSound(
            name: sound.name,
            audioBytes: null,
            audioPath: sound.audioPath,
            imageBytes: null,
            themeId: sound.themeId,
            isAsset: sound.isAsset,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp.title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.red.shade200,
          onPrimary: Colors.grey.shade100,
          secondary: const Color.fromARGB(200, 239, 233, 233),
          onSecondary: Colors.grey.shade900,
          error: Colors.red.shade500,
          onError: Colors.grey.shade900,
          background: Colors.grey.shade100,
          onBackground: Colors.grey.shade900,
          surface: Colors.grey.shade100,
          onSurface: Colors.grey.shade900,
        ),
        textTheme: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.blueGrey, displayColor: Colors.black),
      ),
      home: const Homepage(),
    );
  }
}
