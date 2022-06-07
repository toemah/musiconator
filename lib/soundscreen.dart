import "dart:typed_data";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:musiconator/hiveutils.dart";
import "package:musiconator/main.dart";
import "package:musiconator/sound.dart";
import "package:musiconator/soundtheme.dart";
import "package:musiconator/themescreen.dart";

/*
  Page d'ajout des sons pour un thème donné
 */
class SoundScreen extends StatefulWidget {
  final Sound? sound;
  final SoundTheme theme;

  const SoundScreen({Key? key, this.sound, required this.theme})
      : super(key: key);

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  late SoundTheme theme = widget.theme;
  late Sound? sound = widget.sound;
  SoundTheme? dropdownSoundThemeValue;
  Sound? dropdownSoundValue;
  late String? selectedAudioName = sound != null ? sound!.name : null;
  late Uint8List? selectedAudioBytes = sound != null ? sound!.audioBytes : null;
  late String? selectedAudioPath =
      sound != null ? sound!.audioPath : null; // isAsset
  late Uint8List? selectedImageBytes = sound != null ? sound!.imageBytes : null;
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
          : "Son ${HiveUtils.soundBox.values.where((e) => e.themeId == theme.id).toList().length + 1}";
    });
  }

  // Fonction d'ajout de son via l'explorateur de fichier de l'appareil, les données du son sélectionnés sont ensuite sauvegardés dans une variable puis seront enregistré dans Hive à la confirmation
  Future<void> addSoundFromDevice() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      withData: true,
    );
    if (result != null) {
      setState(() {
        selectedAudioBytes = result.files.single.bytes;
        selectedAudioName = result.files.single.name;
        selectedAudioPath = null;
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

  // Fonction d'ajout d'image dont les données sont sauvegardés dans une variable
  Future<void> addImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (result != null) {
      setState(() {
        selectedImageBytes = result.files.single.bytes!;
      });
    }
  }

  // Lorsque l'utilisateur valide son choix de son et d'image
  void confirm() {
    String name = soundNameField.text;
    if (sound != null) { // Si l'utilisateur avait demandé à faire une mise à jour des informations du son, celle-ci sont mises à jour dans la bdd locale Hive
      print(selectedAudioPath);
      HiveUtils.updateSound(
        id: sound!.id!,
        name: name[0].toUpperCase() + name.substring(1).toLowerCase(),
        audioBytes: selectedAudioBytes,
        audioPath: selectedAudioPath,
        imageBytes: selectedImageBytes,
      );
    } else { // Si l'utilisateur veut au contraire ajouter un son, celui-ci et son image sont sauvegardés dans la bdd locale Hive
      HiveUtils.addSound(
        name: name[0].toUpperCase() + name.substring(1).toLowerCase(),
        audioBytes: selectedAudioBytes,
        audioPath: selectedAudioPath,
        imageBytes: selectedImageBytes,
        themeId: theme.id,
        isAsset: false,
      );
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ThemeScreen(theme: theme),
      ),
      (Route<dynamic> route) => false,
    ).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.red.shade200,
                Colors.purple,
              ],
            ),
          ),
        ),
        title: Image.asset("assets/images/musiconator.png", height: 80.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MyApp.spacing),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - imageWidth,
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
                                  decoration: selectedImageBytes != null
                                      ? BoxDecoration(
                                          image: DecorationImage(
                                            image: Image.memory(
                                                    selectedImageBytes!)
                                                .image,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : BoxDecoration(
                                          color:
                                              Theme.of(context).primaryColor),
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
                                      color: Colors.grey.shade100,
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
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                                    selectedAudioName ??
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
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.greenAccent.shade700),
                      ),
                      onPressed: (selectedAudioBytes != null ||
                                  selectedAudioPath != null) &&
                              soundNameField.text != ""
                          ? confirm
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
