import "package:flutter/material.dart";
import "package:musiconator/hiveutils.dart";
import "package:musiconator/homepage.dart";
import "package:musiconator/main.dart";
import "package:musiconator/sound.dart";
import "package:musiconator/soundWidget.dart";
import "package:musiconator/soundscreen.dart";
import "package:musiconator/soundtheme.dart";

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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.red.shade200,
                Colors.purple,
              ],
            ),
          ),
        ),
        title: Image.asset("assets/images/musiconator.png", height: 80.0),
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
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                border: Border.all(
                  color: Colors.red.shade400,
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                "Supprimer le thème",
                style: TextStyle(
                  color: Colors.grey.shade100,
                ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          (e) => SoundWidget(
                            sound: e,
                            size: soundWidgetSize,
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
        label: const Text("Ajouter un Son"),
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SoundScreen(
                theme: theme,
              ),
            ),
          ),
        },
      ),
    );
  }
}
