import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundscreen.dart';

class SoundWidget extends StatefulWidget {
  final bool isAsset;
  final Sound sound;

  const SoundWidget({Key? key, this.isAsset = false, required this.sound})
      : super(key: key);

  @override
  State<SoundWidget> createState() => _SoundWidgetState();
}

class _SoundWidgetState extends State<SoundWidget> {
  late Sound sound = widget.sound;
  late var player =
      widget.isAsset ? AudioCache(prefix: MyApp.assetsPath) : AudioPlayer();
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
      (player as AudioCache).play(sound.path);
    } else {
      await (player as AudioPlayer).play(sound.path, isLocal: true);
    }
  }

  Widget actionButton(String text, IconData icon, Function()? _onPressed) {
    return MaterialButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(text), Icon(icon)],
      ),
      onPressed: _onPressed,
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
      minWidth: 100.0,
      height: 100.0,
      child: Stack(
        children: [
          sound.imagePath == null
              ? ElevatedButton(
                  onPressed: play,
                  onLongPress: showActions,
                  child: Center(
                    child: Text(
                      sound.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.headline6!.fontSize),
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
                            backgroundColor: const Color.fromARGB(127, 0, 0, 0),
                            fontSize: Theme.of(context)
                                .textTheme
                                .headline6!
                                .fontSize),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          File(sound.imagePath!),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
          Visibility(
            visible: actionsVisibility,
            child: Material(
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: actionButton(
                            "Modifier", Icons.edit_outlined, widget.isAsset ? null : editAction),
                      ),
                      const Divider(),
                      Expanded(
                        flex: 1,
                        child: actionButton(
                            "Supprimer", Icons.delete_outlined, () => {}),
                      ),
                      const Divider(),
                      Expanded(
                        flex: 1,
                        child: actionButton(
                            "Annuler", Icons.cancel_outlined, cancelAction),
                      )
                    ],
                  ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
