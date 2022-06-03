import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundtheme.dart';

class SoundScreen extends StatefulWidget {
  final Sound? sound;

  const SoundScreen({Key? key, this.sound}) : super(key: key);

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  late Sound? sound = widget.sound;
  SoundTheme? dropdownSoundThemeValue;
  Sound? dropdownSoundValue;
  TextEditingController soundNameField = TextEditingController();
  TextEditingController imageNameField = TextEditingController();
  bool soundFromBank = false;
  double imageWidth = 200.0;

  late Function()? audioBtnFromSoundbank = addSoundFromSoundbank;
  late Function()? audioBtnFromDevice = addSoundFromDevice;

  @override
  void initState() {
    super.initState();
    setState(() {
      soundNameField.text =
          sound != null ? sound!.name : "Son ${MyApp.sounds.length}";
      imageNameField.text = 'C:/Users/Florent/Downloads/image.jpg';
    });
  }

  Future<void> addSoundFromSoundbank() async {

  }

  Future<void> addSoundFromDevice() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'flac'],
    );

    if (result?.files.first != null && result != null) {
      soundNameField.text = result.files.first.name;
      print(result.files.first.path);
    }
  }

  Future<void> addImageFromDevice() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print(result.files.first.path);
      imageNameField.text = result.files.first.path!;
      print(imageNameField);
    } else {
      // User canceled the picker
    }
  }

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
          child: SizedBox(
            width: MyApp.maxWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                    Wrap(
                      alignment:
                          MediaQuery.of(context).size.width < MyApp.maxWidth
                              ? WrapAlignment.center
                              : WrapAlignment.start,
                      spacing: MyApp.spacing,
                      runSpacing: MyApp.spacing,
                      children: [
                        SizedBox(
                          height: imageWidth,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              child: Container(
                                child: const FittedBox(
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(127, 0, 0, 0),
                                ),
                              ),
                              decoration:
                                  sound == null || sound!.imagePath == null
                                      ? BoxDecoration(
                                          color: Theme.of(context).primaryColor)
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
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width < MyApp.maxWidth
                                  ? double.maxFinite
                                  : MyApp.maxWidth - imageWidth - MyApp.spacing,
                          height: imageWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                runSpacing: MyApp.spacing,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Flexible(
                                        child: Text(
                                          "Choisir depuis un son depuis la biblithèque ?",
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                      Checkbox(
                                        value: soundFromBank,
                                        onChanged: (bool? value) {
                                          setState(
                                            () {
                                              soundFromBank = value!;
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Visibility(
                                        visible: !soundFromBank,
                                        child: ElevatedButton(
                                          onPressed: audioBtnFromSoundbank,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  sound != null
                                                      ? sound!.path
                                                      : "Ajouter un son depuis l'appareil",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const Icon(
                                                  Icons.folder_open_outlined),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: soundFromBank,
                                        child: Column(
                                          children: [
                                            DropdownButton<SoundTheme>(
                                              isExpanded: true,
                                              value: dropdownSoundThemeValue,
                                              hint: const Text(
                                                "Sélectionnez un thème",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              items:
                                                  MyApp.defaultThemes.map((e) {
                                                return DropdownMenuItem<
                                                    SoundTheme>(
                                                  value: e,
                                                  child: Text(e.name),
                                                );
                                              }).toList(),
                                              onChanged: (SoundTheme? value) {
                                                setState(
                                                  () {
                                                    dropdownSoundThemeValue =
                                                        value!;
                                                  },
                                                );
                                              },
                                            ),
                                            DropdownButton<Sound>(
                                              isExpanded: true,
                                              value: dropdownSoundValue,
                                              hint: const Text(
                                                "Sélectionnez un son",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              items: dropdownSoundThemeValue !=
                                                      null
                                                  ? MyApp.defaultSounds
                                                      .where((e) =>
                                                          e.themeId ==
                                                          dropdownSoundThemeValue!
                                                              .id)
                                                      .map((e) {
                                                      return DropdownMenuItem<
                                                          Sound>(
                                                        value: e,
                                                        child: Text(e.name),
                                                      );
                                                    }).toList()
                                                  : null,
                                              onChanged: (Sound? value) {
                                                setState(
                                                  () {
                                                    dropdownSoundValue = value!;
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                      sound != null ? "Confirmer" : "Ajouter",
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
