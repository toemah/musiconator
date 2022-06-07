import "package:audioplayers/audioplayers.dart";
import "package:flutter/material.dart";
import "package:musiconator/hiveutils.dart";
import "package:musiconator/sound.dart";
import "package:musiconator/soundscreen.dart";
import "package:musiconator/themescreen.dart";

class SoundWidget extends StatefulWidget {
  final Sound sound;
  final double size;

  const SoundWidget({Key? key, required this.sound, required this.size})
      : super(key: key);

  @override
  State<SoundWidget> createState() => _SoundWidgetState();
}

class _SoundWidgetState extends State<SoundWidget> {
  late Sound sound = widget.sound;
  // Si le son est un asset AudioCache doit être utilisé
  // sinon AudioPlayer, c'est une contrainte du plugin
  late var player = sound.audioPath != null
      ? AudioCache(prefix: "assets/audio/")
      : AudioPlayer();
  bool actionsVisibility = false;

  @override
  void dispose() {
    super.dispose();
    if (player is AudioCache) {
      (player as AudioCache).clearAll();
    }
  }

  // Cette fonction joue le son, si c'est asset avec la méthode play d'AudioCache
  // sinon avec la méthode playBytes puisque c'est le format enregistré dans Hive
  void play() async {
    if (player is AudioCache) {
      (player as AudioCache).play(sound.audioPath!);
    } else {
      await (player as AudioPlayer).playBytes(sound.audioBytes!);
    }
  }

  // Cette fonction créer un bouton avec les paramètres fournis
  // ce bouton est déstiné à être utilisé au sein de l'overlay d'actions
  Widget actionButton({
    required String text,
    required IconData icon,
    Color? iconColor,
    Function()? onPressed,
  }) {
    return MaterialButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              // Un peu de de calcul pour garder la taille du texte sous controle
              // selon la taille du widget
              fontSize: 5.5 + widget.size * 0.05,
            ),
          ),
          IconTheme(
            data: IconThemeData(
              // Si il n'y pas de fonction, donner une apparence inactive à l'icone
              color:
                  onPressed != null ? iconColor ?? Colors.black : Colors.grey,
            ),
            child: Icon(icon),
          ),
        ],
      ),
      onPressed: onPressed,
      disabledColor: Colors.grey.shade200,
      disabledTextColor: Colors.grey,
    );
  }

  void showActions() {
    setState(() {
      actionsVisibility = true;
    });
  }

  void hideActions() {
    setState(() {
      actionsVisibility = false;
    });
  }

  void deleteAction() {
    HiveUtils.deleteSound(sound.id!);
    // Petite astuce pour recharger une page complètement aprês que les données sont mises à jour
    // cette méthode ordone à l'application de se diriger vers l'écran actuel
    // tout en supprimant l'historique de navigation afin que revenir en arrière ramène à l'accueil
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ThemeScreen(
          theme: HiveUtils.soundThemeBox.getAt(sound.themeId)!,
        ),
      ),
      (Route<dynamic> route) => false,
    ).then((value) {
      setState(() {});
    });
  }

  void editAction() {
    hideActions();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SoundScreen(
          sound: sound,
          theme: HiveUtils.soundThemeBox.getAt(sound.themeId)!,
        ),
      ),
    );
  }

  void cancelAction() {
    hideActions();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      child: AspectRatio(
        aspectRatio: 1,
        // En utilisant un Stack, le bouton et l'overlay d'action sont superposés
        child: Stack(
          children: [
            ButtonTheme(
              // S'il n'y a pas d'images utiliser un bouton avec un arrière plan uni
              child: sound.imageBytes == null
                  ? ElevatedButton(
                      onPressed: play,
                      onLongPress: showActions,
                      child: Center(
                        child: Text(
                          sound.name,
                          style: TextStyle(
                              color: Colors.grey.shade100,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .fontSize),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  // sinon image en arrière plan
                  : Container(
                      child: MaterialButton(
                        onPressed: play,
                        onLongPress: showActions,
                        child: Center(
                          child: Text(
                            sound.name,
                            style: TextStyle(
                                color: Colors.grey.shade100,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .fontSize),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        // Simuler le radius par défaut d'ElevatedButton
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3.0)),
                        image: DecorationImage(
                          // Filtre pour assombrir l'image est amélioré le contraste
                          colorFilter: const ColorFilter.mode(
                            Color.fromARGB(127, 0, 0, 0),
                            BlendMode.darken,
                          ),
                          image: Image.memory(sound.imageBytes!).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            // L'overlay n'apparait qu'après un appui long
            Visibility(
              visible: actionsVisibility,
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: actionButton(
                        text: "Modifier",
                        icon: Icons.edit_outlined,
                        iconColor: Colors.yellowAccent.shade700,
                        onPressed: sound.isAsset ? null : editAction,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: actionButton(
                        text: "Supprimer",
                        icon: Icons.delete_outlined,
                        iconColor: Colors.redAccent.shade700,
                        onPressed: deleteAction,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: actionButton(
                        text: "Annuler",
                        icon: Icons.cancel_outlined,
                        onPressed: cancelAction,
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
