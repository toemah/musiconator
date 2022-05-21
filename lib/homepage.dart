import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late AudioCache player = AudioCache(prefix: 'assets/audio/');

  @override
  void initState() {
    super.initState();
    player.load('explosion.mp3');
  }

  @override
  void dispose() {
    super.dispose();
    player.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: const Center(
        child: Text("Hello World"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {player.play('explosion.mp3')},
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
