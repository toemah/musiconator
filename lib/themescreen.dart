import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundWidget.dart';
import 'package:musiconator/soundtheme.dart';

class ThemeScreen extends StatefulWidget {
  final SoundTheme theme;

  const ThemeScreen({Key? key, required this.theme}) : super(key: key);

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  late SoundTheme theme = widget.theme;
  late List<Sound> sounds =
      MyApp.sounds.where((e) => e.themeId == theme.id).toList();
  double soundWidgetSize = 200.0; 
  TextEditingController themeNameField = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      themeNameField.text = theme.name;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MyApp.spacing),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: MyApp.maxWidthLarge),
              child: Column(
                crossAxisAlignment: MediaQuery.of(context).size.width < soundWidgetSize * 2 + MyApp.spacing * 3
                                    ? CrossAxisAlignment.center
                                    : CrossAxisAlignment.start,
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
                    spacing: MyApp.spacing,
                    runSpacing: MyApp.spacing,
                    children: sounds
                        .map(
                          (e) => SizedBox(
                            width: soundWidgetSize,
                            height: soundWidgetSize,
                            child: SoundWidget(
                              isAsset: e.id == -1,
                              sound: e,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
