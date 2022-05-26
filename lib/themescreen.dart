import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/soundtheme.dart';

class ThemeScreen extends StatefulWidget {
  final List<SoundTheme> themes;

  const ThemeScreen({
    Key? key,
    required this.themes,
  }) : super(key: key);

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(),
      )
    );
  }
}
