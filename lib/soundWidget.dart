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
    return widget.imagePath == null
        ? ElevatedButton(
            onPressed: play,
            child: Center(
              child: Text(widget.name),
            ),
          )
        : MaterialButton(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Center(
                child: Text(
                  widget.name,
                  style: const TextStyle(color: Colors.white),),
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
          );
  }
}
