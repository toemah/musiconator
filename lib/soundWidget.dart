import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundscreen.dart';

class SoundWidget extends StatefulWidget {
  final Sound sound;

  const SoundWidget({Key? key, required this.sound}) : super(key: key);

  @override
  State<SoundWidget> createState() => _SoundWidgetState();
}

class _SoundWidgetState extends State<SoundWidget> {
  late Sound sound = widget.sound;
  late var player =
      sound.isAsset ? AudioCache(prefix: MyApp.assetsPath) : AudioPlayer();
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
      if (sound.isAsset) {
        (player as AudioCache).play(sound.audioPath!);
      } else {
        (player as AudioCache).playBytes(sound.audioBytes!);
      }
    } else {
      if (sound.isAsset) {
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
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
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

  void editAction() {
    hideActions();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SoundScreen(
          sound: sound,
          themeId: sound.themeId,
        ),
      ),
    );
  }

  void cancelAction() {
    hideActions();
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: Stack(
        children: [
          sound.imageBytes == null
              ? ElevatedButton(
                  onPressed: play,
                  onLongPress: showActions,
                  child: Center(
                    child: Text(
                      sound.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : MaterialButton(
                  onPressed: play,
                  onLongPress: showActions,
                  child: Container(
                    child: Center(
                      child: Text(
                        sound.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headline6!
                                .fontSize),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(127, 0, 0, 0),
                      image: DecorationImage(
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
                      iconColor: Colors.yellow,
                      onPressed: sound.isAsset ? null : editAction,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: actionButton(
                      text: "Supprimer",
                      icon: Icons.delete_outlined,
                      iconColor: Colors.red,
                      onPressed: () => {},
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
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
