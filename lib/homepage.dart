import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/soundtheme.dart';
import 'package:musiconator/themescreen.dart';

import 'hiveutils.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    Key? key,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late List<SoundTheme> themes;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    themes = HiveUtils.soundThemeBox.values.where((e) => !e.hide).toList();
    themes.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  void showForm(BuildContext ctx, List themes) async {
    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Nom du theme',
                hintStyle: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.greenAccent.shade700),
              ),
              onPressed: () async {
                themes.add(
                  SoundTheme(
                    id: HiveUtils.soundThemeBox.length,
                    name: _nameController.text,
                    isDefault: false,
                    hide: false,
                  ),
                );
                themes.sort((a, b) =>
                    a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                HiveUtils.addTheme(
                  name: _nameController.text,
                  isDefault: false,
                  hide: false,
                );
                setState(() {});
                _nameController.text = '';
                Navigator.of(ctx).pop();
              },
              child: const Text("Ajouter"),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MyApp.spacing),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: MyApp.maxWidth),
            child: ListView.builder(
              itemCount: themes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: MyApp.spacing),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThemeScreen(
                          theme: themes[index],
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: MyApp.spacing, bottom: MyApp.spacing),
                      child: Text(
                        themes[index].name[0].toUpperCase() +
                            themes[index].name.substring(1).toLowerCase(),
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .fontSize,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Ajouter un Theme'),
        onPressed: () => {
          showForm(context, themes),
        },
      ),
    );
  }
}
