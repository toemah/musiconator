import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';

class SoundScreen extends StatefulWidget {
  final int soundId;
  final String soundName;
  final String path;
  final String? imagePath;
  final int themeId;

  const SoundScreen(
      {Key? key,
      required this.soundId,
      required this.soundName,
      required this.path,
      this.imagePath,
      required this.themeId})
      : super(key: key);

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(63, 68, 75, 1),
      appBar: AppBar(
        title: const Text(MyApp.title),
        titleTextStyle: const TextStyle(
            letterSpacing: 2, color: Colors.white, fontSize: 25),
        backgroundColor:
            const Color.fromRGBO(51, 55, 61, 1), // status bar color
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(40.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(63, 68, 75, 1),
              border: Border.all(
                  color: const Color.fromRGBO(78, 83, 91, 1),
                  width: 6.0,
                  style: BorderStyle.solid),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: widget.imagePath != null
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(
                              File(widget.imagePath!),
                            ),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const BoxDecoration(
                          color: Colors.blue,
                        ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Text(
                  "Votre son est [${widget.soundId}] ${widget.soundName}",
                  style: const TextStyle(
                      fontSize: 18, color: Colors.white, letterSpacing: 2),
                ),
                const SizedBox(
                  height: 35,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: OutlinedButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            primary: Colors.white,
                            textStyle:
                                const TextStyle(fontSize: 18, letterSpacing: 2),
                          ),
                          icon: const Icon(
                            Icons.add,
                            size: 24.0,
                          ),
                          onPressed: () {},
                          label: const Text('Ajouter un Son'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
