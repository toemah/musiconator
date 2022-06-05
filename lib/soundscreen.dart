import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:musiconator/hiveutils.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/sound.dart';
import 'package:musiconator/soundtheme.dart';

class SoundScreen extends StatefulWidget {
  final Sound? sound;
  final int themeId;

  const SoundScreen({Key? key, this.sound, required this.themeId})
      : super(key: key);

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  late Sound? sound = widget.sound;
  SoundTheme? dropdownSoundThemeValue;
  Sound? dropdownSoundValue;
  String? selectedAudioName;
  Uint8List? selectedAudioBytes;
  String? selectedAudioPath; // isAsset
  Uint8List? selectedImageBytes;
  List<Sound>? soundsFromBank;
  TextEditingController soundNameField = TextEditingController();
  bool isFromBank = false;
  double imageWidth = 200.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      soundNameField.text = sound != null
          ? sound!.name
          : "Son ${HiveUtils.soundBox.values.where((e) => e.themeId == widget.themeId).toList().length + 1}";
    });
  }

  Future<void> addSoundFromDevice() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      selectedAudioBytes = result.files.single.bytes;
      setState(() {
        selectedAudioName = result.files.single.name;
      });
    }
  }

  void removeImage(BuildContext context) {
    setState(() {
      selectedImageBytes = null;
    });
    Navigator.pop(context);
  }

  void editImage(BuildContext context) {
    addImage();
    Navigator.pop(context);
  }

  Future<void> addImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (result != null) {
      setState(() {
        selectedImageBytes = result.files.single.bytes!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
        backgroundColor: Color.fromARGB(255, 0, 153, 254),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MyApp.spacing),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height - MyApp.spacing * 10,
                maxWidth: MyApp.maxWidth,
              ),
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
                            width: imageWidth,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: selectedImageBytes == null
                                      ? BoxDecoration(
                                          color: Theme.of(context).primaryColor)
                                      : BoxDecoration(
                                          image: DecorationImage(
                                            image: Image.memory(
                                                    selectedImageBytes!)
                                                .image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(127, 0, 0, 0),
                                    ),
                                    child: IconButton(
                                      onPressed: selectedImageBytes == null
                                          ? addImage
                                          : () => showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text(
                                                      "Que souhaitez-vous faire?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          editImage(context),
                                                      child: const Text(
                                                          "Modifier"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          removeImage(context),
                                                      child: const Text(
                                                          "Supprimer"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      icon: const Icon(Icons.add_a_photo),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width <
                                    MyApp.maxWidth
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
                                            "Choisir depuis un son depuis la bibliothèque ?",
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                        Checkbox(
                                          value: isFromBank,
                                          onChanged: (bool? value) {
                                            setState(
                                              () {
                                                isFromBank = value!;
                                                dropdownSoundThemeValue = null;
                                                dropdownSoundValue = null;
                                                selectedAudioName = null;
                                                selectedAudioBytes = null;
                                                selectedAudioPath = null;
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Visibility(
                                          visible: !isFromBank,
                                          child: ElevatedButton(
                                            onPressed: addSoundFromDevice,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    sound != null
                                                        ? sound!.name
                                                        : selectedAudioName ??
                                                            "Ajouter un son depuis l'appareil",
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
                                          visible: isFromBank,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                items: MyApp.defaultThemes
                                                    .map((e) {
                                                  return DropdownMenuItem<
                                                      SoundTheme>(
                                                    value: e,
                                                    child: Text(e.name),
                                                  );
                                                }).toList(),
                                                onChanged: (SoundTheme? value) {
                                                  setState(() {
                                                    dropdownSoundThemeValue =
                                                        value!;
                                                    dropdownSoundValue = null;
                                                    selectedAudioName = null;
                                                    selectedAudioBytes = null;
                                                    soundsFromBank = MyApp
                                                        .defaultSounds
                                                        .where((e) =>
                                                            e.themeId ==
                                                            dropdownSoundThemeValue!
                                                                .id)
                                                        .toList();
                                                  });
                                                },
                                              ),
                                              Visibility(
                                                visible:
                                                    dropdownSoundThemeValue !=
                                                        null,
                                                child: soundsFromBank != null &&
                                                        soundsFromBank!
                                                            .isNotEmpty
                                                    ? DropdownButton<Sound>(
                                                        isExpanded: true,
                                                        value:
                                                            dropdownSoundValue,
                                                        hint: const Text(
                                                          "Sélectionnez un son",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        items: soundsFromBank
                                                            ?.map((e) {
                                                          return DropdownMenuItem<
                                                              Sound>(
                                                            value: e,
                                                            child: Text(e.name),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (Sound? value) {
                                                          setState(
                                                            () {
                                                              dropdownSoundValue =
                                                                  value!;
                                                              selectedAudioName =
                                                                  value.name;
                                                              selectedAudioPath =
                                                                  value
                                                                      .audioPath;
                                                            },
                                                          );
                                                        },
                                                      )
                                                    : const Text(
                                                        "Aucun son disponible",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
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
                      onPressed: selectedAudioBytes != null ||
                              selectedAudioPath != null
                          ? () => {}
                          : null,
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
      ),
    );
  }
}
