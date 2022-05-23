import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';

class SoundWidget extends StatefulWidget {
  final bool isAsset;
  final int? soundId;
  final String name;
  final String path;
  final String imagePath;
  final int? themeId;

  const SoundWidget(
      {Key? key,
      this.isAsset = false,
      this.soundId, // if isAsset then soundId is null
      required this.name,
      required this.path,
      required this.imagePath,
      this.themeId // if isAsset then themeId is null
    }) : super(key: key);

  @override
  State<SoundWidget> createState() => _SoundWidgetState();
}

class _SoundWidgetState extends State<SoundWidget> {
  late var player = widget.isAsset ? AudioCache(prefix: MyApp.assetsPath) : AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if(player is AudioCache) {
      (player as AudioCache).clearAll();
    }
  }

  void play(String path) async {
    if(player is AudioCache) {
      (player as AudioCache).play(path);
    } else {
      await (player as AudioPlayer).play(path, isLocal: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Center(
        child: Text(widget.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {play(widget.path)},
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
 
