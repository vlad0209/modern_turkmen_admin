import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modern_turkmen_admin/widgets/dropzone.dart';

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
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  const ExerciseItem(
      {super.key,
      required this.onRemove,
      required this.controller,
      required this.auth,
      required this.storage});

  @override
  State<ExerciseItem> createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  final _addFormKey = GlobalKey<FormState>();
  final AudioPlayer player = AudioPlayer();
  late String soundUrl;
  PlayerState? playerState;
  bool loadingAudio = false;
  Future? soundFuture;
  late String documentId;

  @override
  void initState() {
    soundUrl = widget.controller.soundUrl;
    if (soundUrl.isNotEmpty) {
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
                    decoration: const InputDecoration(
                        labelText:
                            'Solution (use <f/> tag to add word placeholders'),
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
                    decoration: const InputDecoration(
                        labelText: 'Options (comma separated)'),
                    initialValue: widget.controller.options,
                    onChanged: (value) {
                      widget.controller.options = value;
                    },
                  )),
              const SizedBox(
                width: 9,
              ),
              soundUrl.isEmpty
                  ? Dropzone(
                      width: 200,
                      height: 200,
                      label: 'Sound',
                      auth: widget.auth,
                      mime: const ['audio/mp3', 'audio/mp4'],
                      mimeErrorMessage: 'Only audio/mp3 and audio/mp3 allowed',
                      onFileUploaded: (String downloadUrl) {
                        soundFuture = player.setSourceUrl(downloadUrl);
                        setState(() {
                          soundUrl = downloadUrl;
                        });
                      },
                      storage: widget.storage,
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
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }
}
