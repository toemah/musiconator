import 'package:flutter/material.dart';
import 'package:musiconator/hiveutils.dart';
import 'package:musiconator/homepage.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundWidget.dart';
import 'package:musiconator/soundscreen.dart';
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
      HiveUtils.soundBox.values.where((e) => e.themeId == theme.id).toList();
  double soundWidgetSize = 125.0;
  TextEditingController themeNameField = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      themeNameField.text = theme.name;
    });
  }

  void updateName() {
    HiveUtils.updateTheme(id: theme.id, name: themeNameField.text);
  }

  void backToHomepage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const Homepage(),
      ),
      (Route<dynamic> route) => false,
    ).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: backToHomepage,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (theme.isDefault) {
                HiveUtils.updateTheme(
                  id: theme.id,
                  name: theme.name,
                  isDefault: theme.isDefault,
                  hide: true,
                );
              } else {
                HiveUtils.deleteTheme(theme.id);
              }
              backToHomepage();
            },
            child: const Text(
              "Supprimer",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(MyApp.spacing),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: MyApp.maxWidthLarge),
              child: Column(
                crossAxisAlignment: MediaQuery.of(context).size.width <
                        soundWidgetSize * 2 + MyApp.spacing * 3
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: themeNameField,
                    onEditingComplete: () {
                      updateName();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
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
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Son'),
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SoundScreen(
                themeId: theme.id,
              ),
            ),
          ),
        },
      ),
    );
  }
}
