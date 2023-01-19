import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_turkmen_admin/controllers/file_dropzone_controller.dart';
import 'package:modern_turkmen_admin/widgets/file_dropzone.dart';

import '../helpers/uploader.dart';

class ExerciseItemController {
  String soundUrl;
  String options;
  String sentence;
  String solution;
  String translation;

  ExerciseItemController(
      {required this.soundUrl,
      required this.options,
      required this.sentence,
      required this.solution,
      required this.translation});
}

class ExerciseItem extends StatefulWidget {
  final void Function() onRemove;
  final ExerciseItemController controller;

  const ExerciseItem({
    Key? key,
    required this.onRemove,
    required this.controller,
  }) : super(key: key);

  @override
  State<ExerciseItem> createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  final _addFormKey = GlobalKey<FormState>();
  final FileDropzoneController _soundController = FileDropzoneController();
  final AudioPlayer player = AudioPlayer();
  late String soundUrl;
  PlayerState? playerState;
  bool loadingAudio = false;
  Future? soundFuture;
  late String documentId;

  @override
  void initState() {
    soundUrl = widget.controller.soundUrl;
    if (!soundUrl.isNotEmpty) {
      soundFuture = player.setSourceUrl(soundUrl);
    }
    player.onPlayerStateChanged.listen((event) {
      setState(() {
        playerState = event;
        loadingAudio = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addFormKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Sentence'),
                    initialValue: widget.controller.sentence,
                    onChanged: (value) {
                      widget.controller.sentence = value;
                    },
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Solution'),
                    initialValue: widget.controller.solution,
                    onChanged: (value) {
                      widget.controller.solution = value;
                    },
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Translation'),
                    initialValue: widget.controller.translation,
                    onChanged: (value) {
                      widget.controller.translation = value;
                    },
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Options (comma separated)'),
                    initialValue: widget.controller.options,
                    onChanged: (value) {
                      widget.controller.options = value;
                    },
                  )),
              const SizedBox(
                width: 9,
              ),
              soundUrl.isEmpty
                  ? FileDropzone(
                      label: 'Sound (mp3)',
                      onDrop: (files) => uploadSound(files.first),
                      controller: _soundController,
                      fileType: 'mp3',
                    )
                  : Column(
                      children: [
                        if (loadingAudio)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        if (playerState == PlayerState.playing)
                          IconButton(
                              onPressed: () {
                                player.pause();
                              },
                              icon: const Icon(Icons.pause)),
                        if (playerState == PlayerState.paused)
                          IconButton(
                              onPressed: () {
                                player.resume();
                              },
                              icon: const Icon(Icons.play_arrow)),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                soundUrl = '';
                                _soundController.reset();
                                widget.controller.soundUrl = '';
                              });
                            },
                            child: const Text('Replace the sound'))
                      ],
                    ),
              const SizedBox(
                width: 9,
              ),
              IconButton(
                  onPressed: () {
                    widget.onRemove();
                  }, icon: const Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }

  void uploadSound(file) {
    Uploader.uploadFile(file, _soundController, (ref) async {
      String url = await ref.getDownloadURL();

      soundFuture = player.setSourceUrl(url);
      setState(() {
        soundUrl = url;
      });
    });
  }
}
