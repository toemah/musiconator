import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';

class SoundScreen extends StatefulWidget {
  
  final int soundId;
  final String soundName;
  final String path;
  final String imagePath;
  final int themeId;
  
  const SoundScreen({
    Key? key, 
    required this.soundId,
    required this.soundName,
    required this.path,
    required this.imagePath,
    required this.themeId
  }) : super(key: key);
  
  @override
  State<SoundScreen> createState() => _SoundScreenState();

}

class _SoundScreenState extends State<SoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Center(
        child: Text("[${widget.soundId}] ${widget.soundName}"),
      ),
    );
  }
}
