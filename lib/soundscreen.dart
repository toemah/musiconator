import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/sound.dart';

class SoundScreen extends StatefulWidget {
  final Sound? sound;

  const SoundScreen({Key? key, this.sound}) : super(key: key);

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  late Sound? sound = widget.sound;
  TextEditingController soundNameField = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      soundNameField.text = sound != null ? sound!.name : "Son ${MyApp.sounds.length}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: 500.0,
            child: Column(
              children: [
                TextField(
                  controller: soundNameField,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 500.0,
                  child: Container(
                    child: const FittedBox(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white,
                      ),
                    ),
                    decoration: sound == null || sound!.imagePath == null
                        ? BoxDecoration(
                            color: Theme.of(context).backgroundColor)
                        : BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(
                                File(sound!.imagePath!),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: ElevatedButton(
                            onPressed: () => {},
                            child: const Text("Supprimer"),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: ElevatedButton(
                            onPressed: () => {},
                            child: Text(
                              sound == null ||
                                      (sound != null &&
                                          sound!.imagePath == null)
                                  ? "Ajouter"
                                  : "Modifier",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sound != null ? sound!.path : "Ajouter un son",
                          ),
                          const Icon(
                            Icons.add_circle_outline,
                          ),
                        ],
                      ),
                    ),
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
