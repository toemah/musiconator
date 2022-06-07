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
  late var player =
      sound.audioPath != null ? AudioCache(prefix: "assets/audio/") : AudioPlayer();
  bool actionsVisibility = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (player is AudioCache) {
      (player as AudioCache).clearAll();
    }
  }

  void play() async {
    if (player is AudioCache) {
      if (sound.audioPath != null) {
        (player as AudioCache).play(sound.audioPath!);
      } else {
        (player as AudioCache).playBytes(sound.audioBytes!);
      }
    } else {
      if (sound.audioPath != null) {
        await (player as AudioPlayer).play(sound.audioPath!, isLocal: true);
      } else {
        await (player as AudioPlayer).playBytes(sound.audioBytes!);
      }
    }
  }

  Widget actionButton(
      {required String text,
      required IconData icon,
      Color? iconColor,
      Function()? onPressed}) {
    return MaterialButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 5.5 + widget.size * 0.05,
            ),
          ),
          IconTheme(
            data: IconThemeData(
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
        child: Stack(
          children: [
            ButtonTheme(
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3.0)),
                        image: DecorationImage(
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
