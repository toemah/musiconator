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


  Future<void> _createItem(Map<String, dynamic> newItem) async {
    /*await widget.themes.add(newItem);
    _refreshItems(); // update the UI*/
    
  }



class _HomepageState extends State<Homepage> {

    final TextEditingController _nameController = TextEditingController();
    void _showForm(BuildContext ctx, int? itemKey, List themes ) async {
    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Nom du theme'),
              ),
              const SizedBox(
                height: 50,
              ),
              
              ElevatedButton(
                onPressed: () async {

                  themes.add(SoundTheme(id: 4, name: _nameController.text));
                  HiveUtils.addTheme( _nameController.text);
                  setState(() {});
                  _nameController.text = '';
                  Navigator.of(ctx).pop(); // Close the bottom sheet
                },
                child: Text(itemKey == null ? 'Valider' : 'Update'),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ));

  }


  late List<SoundTheme> themes = widget.themes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: themes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
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
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    themes[index].name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize,
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
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Theme'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => {
          _showForm(context, null, themes)
          //setState(() =>  _showForm(context, null, themes))
          },
      ),
    );
  }
}
