import "package:flutter/material.dart";
import "package:musiconator/main.dart";
import "package:musiconator/soundtheme.dart";
import "package:musiconator/themescreen.dart";

import "hiveutils.dart";

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
                hintText: "Nom du theme",
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
                backgroundColor:
                    MaterialStateProperty.all(Colors.greenAccent.shade700),
              ),
              onPressed: () async {
                String name = _nameController.text;
                themes.add(
                  SoundTheme(
                    id: HiveUtils.soundThemeBox.length,
                    name: name[0].toUpperCase() + name.substring(1).toLowerCase(),
                    isDefault: false,
                    hide: false,
                  ),
                );
                themes.sort((a, b) =>
                    a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                HiveUtils.addTheme(
                  name: name[0].toUpperCase() + name.substring(1).toLowerCase(),
                  isDefault: false,
                  hide: false,
                );
                setState(() {});
                _nameController.text = "";
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
        title: Image.asset("assets/images/musiconator.png", height: 80.0),
        centerTitle: true,
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
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: MyApp.maxWidth),
          child: ListView.builder(
            itemCount: themes.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(MyApp.spacing),
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
                      top: MyApp.spacing,
                      bottom: MyApp.spacing,
                    ),
                    child: Text(
                      themes[index].name,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headlineSmall!.fontSize,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.people_outlined,
                color: Colors.white,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text("L'équipe"),
                  content: Text(
                      "Cette application est l'oeuvre d'une petite équipe de 5 étudiants"
                      "passionnés de bruitages poétiques tel que les explosions et les mélodides des toilettes. :-)"),
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text("Comment ça marche ? "),
                  content: Text(
                    "-Choisissez votre catégorie\n"
                    "- Ecoutez les son les plus amusants d'Orsay en appuyant sur le son que vous voulez!\n"
                    "- Vous pouvez personnaliser chaque catégorie en rajoutant des sons rigolo, voir même supprimer des son démodés! :-(\n"
                    "- Vous voulez encore plus de catégories? Et bien c'est tout à fait possible: Vous pouvez créer votre propre catégorie dans le menu principal grâce au bouton \"Ajouter un thème\"!\n"
                    "- Vous pouvez ajouter des sons à n'importe quelle catégorie avec le bouton \"Ajouter un son\" puis vous pouvez les éditer ou supprimer en appyant longtemps dessus!"
                    "-Amusez vous bien ! :-p ",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Ajouter un thème"),
        onPressed: () => {
          showForm(context, themes),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
