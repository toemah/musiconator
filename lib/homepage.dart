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
                  title: Text("L'??quipe"),
                  content: Text(
                      "Cette application est l'oeuvre d'une petite ??quipe de 5 ??tudiants"
                      "passionn??s de bruitages po??tiques tel que les explosions et les m??lodides des toilettes. :-)"),
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
                  title: Text("Comment ??a marche ? "),
                  content: Text(
                    "-Choisissez votre cat??gorie\n"
                    "- Ecoutez les son les plus amusants d'Orsay en appuyant sur le son que vous voulez!\n"
                    "- Vous pouvez personnaliser chaque cat??gorie en rajoutant des sons rigolo, voir m??me supprimer des son d??mod??s! :-(\n"
                    "- Vous voulez encore plus de cat??gories? Et bien c'est tout ?? fait possible: Vous pouvez cr??er votre propre cat??gorie dans le menu principal gr??ce au bouton \"Ajouter un th??me\"!\n"
                    "- Vous pouvez ajouter des sons ?? n'importe quelle cat??gorie avec le bouton \"Ajouter un son\" puis vous pouvez les ??diter ou supprimer en appyant longtemps dessus!"
                    "-Amusez vous bien ! :-p ",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Ajouter un th??me"),
        onPressed: () => {
          showForm(context, themes),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
