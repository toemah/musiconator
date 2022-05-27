import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundWidget.dart';

class ThemeScreen extends StatefulWidget {
  final int themeId;
  final String themeName;

  const ThemeScreen({
    Key? key,
    required this.themeId,
    required this.themeName,
  }) : super(key: key);

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  late List<Sound> sounds =
      MyApp.sounds.where((e) => e.themeId == widget.themeId).toList();

  TextEditingController themeNameField = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      themeNameField.text = widget.themeName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: themeNameField,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
              const Divider(),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: sounds
                    .map(
                      (e) => SizedBox(
                        width: 200.0,
                        height: 200.0,
                        child: SoundWidget(
                          isAsset: e.id == -1,
                          soundId: e.id,
                          name: e.name,
                          path: e.path,
                          imagePath: e.imagePath,
                          themeId: e.themeId,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
