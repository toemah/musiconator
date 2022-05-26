import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';

class SoundWidget extends StatefulWidget {
  final bool isAsset;
  final int? soundId;
  final String name;
  final String path;
  final String? imagePath;
  final int? themeId;

  const SoundWidget(
      {Key? key,
      this.isAsset = false,
      this.soundId, // if isAsset then soundId is null
      required this.name,
      required this.path,
      this.imagePath,
      this.themeId // if isAsset then themeId is null
      })
      : super(key: key);

  @override
  State<SoundWidget> createState() => _SoundWidgetState();
}

class _SoundWidgetState extends State<SoundWidget> {
  late var player =
      widget.isAsset ? AudioCache(prefix: MyApp.assetsPath) : AudioPlayer();

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
      (player as AudioCache).play(widget.path);
    } else {
      await (player as AudioPlayer).play(widget.path, isLocal: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 100.0,
      height: 100.0,
      child: widget.imagePath == null
          ? ElevatedButton(
              onPressed: play,
              child: Center(
                child: Text(
                  widget.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          Theme.of(context).textTheme.headline6!.fontSize),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : MaterialButton(
              child: Container(
                child: Center(
                  child: Text(
                    widget.name,
                    style: TextStyle(
                        color: Colors.white,
                        backgroundColor: const Color.fromARGB(127, 0, 0, 0),
                        fontSize:
                            Theme.of(context).textTheme.headline6!.fontSize),
                    textAlign: TextAlign.center,
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(
                      File(widget.imagePath!),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onPressed: play,
            ),
    );
  }
}
