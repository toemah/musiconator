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

  late Function()? audioBtnFromSoundbank =
      sound != null && sound!.id == -1 ? addFromSoundbank : null;
  late Function()? audioBtnFromDevice =
      sound != null && sound!.id != -1 ? addFromDevice : null;

  @override
  void initState() {
    super.initState();
    setState(() {
      soundNameField.text =
          sound != null ? sound!.name : "Son ${MyApp.sounds.length}";
    });
  }

  void addFromSoundbank() {}

  void addFromDevice() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MyApp.spacing),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: MyApp.maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: const EdgeInsets.only(
                        top: MyApp.spacing, bottom: MyApp.spacing),
                    child: Text(
                      "Image",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      child: const FittedBox(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white,
                        ),
                      ),
                      decoration: sound == null || sound!.imagePath == null
                          ? BoxDecoration(color: Theme.of(context).primaryColor)
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
                            padding:
                                const EdgeInsets.only(left: 2.0, right: 2.0),
                            child: ElevatedButton(
                              onPressed: () => {},
                              child: const Text("Supprimer"),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 2.0, right: 2.0),
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
                    padding: const EdgeInsets.only(
                      top: MyApp.spacing,
                    ),
                    child: Text(
                      "Audio",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: ElevatedButton(
                                onPressed: audioBtnFromSoundbank,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        audioBtnFromSoundbank != null
                                            ? sound!.path
                                            : "Ajouter un son depuis l'appareil",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(Icons.folder_open_outlined),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 2.0, right: 2.0),
                            child: ElevatedButton(
                              onPressed: audioBtnFromSoundbank != null
                                  ? () => {}
                                  : null,
                              child: const Icon(Icons.remove),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: ElevatedButton(
                                onPressed: audioBtnFromDevice,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        audioBtnFromDevice != null
                                            ? sound!.path
                                            : "Ajouter un son depuis l'appareil",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(Icons.folder_open_outlined),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 2.0, right: 2.0),
                            child: ElevatedButton(
                              onPressed:
                                  audioBtnFromDevice != null ? () => {} : null,
                              child: const Icon(Icons.remove),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: MyApp.spacing),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => {},
                          child: Text(
                            sound != null ? "Confirmer" : "Ajouter",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
