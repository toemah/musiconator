import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/soundtheme.dart';
import 'package:musiconator/themescreen.dart';

import 'hiveutils.dart';

class Homepage extends StatefulWidget {
  final List<SoundTheme> themes;

  const Homepage({
    Key? key,
    required this.themes,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late List<SoundTheme> themes = widget.themes;
  final TextEditingController _nameController = TextEditingController();

  void _showForm(BuildContext ctx, int? itemKey, List themes) async {
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
                hintStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                themes.add(
                  SoundTheme(
                    id: themes.length,
                    name: _nameController.text,
                  ),
                );
                HiveUtils.addTheme(_nameController.text);
                setState(() {});
                _nameController.text = '';
                Navigator.of(ctx).pop();
              },
              child: Text(itemKey == null ? 'Valider' : 'Update'),
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
                        themes[index].name,
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
        icon: const Icon(Icons.add),
        label: const Text('Theme'),
        onPressed: () => {
          _showForm(context, null, themes),
        },
      ),
    );
  }
}
