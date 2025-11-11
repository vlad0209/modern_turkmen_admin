import 'package:flutter/material.dart';
import 'package:modern_turkmen_admin/ui/core/ui/dropzone.dart';

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

class ExerciseItemWidget extends StatefulWidget {
  final void Function() onRemove;
  final ExerciseItemController controller;
  final Function setSourceUrl;
  final Stream<void> onPlayerStateChanged;
  final Function pauseAudio;
  final Function resumeAudio;

  const ExerciseItemWidget(
      {super.key,
      required this.onRemove,
      required this.controller,
      required this.setSourceUrl,
      required this.onPlayerStateChanged,
      required this.pauseAudio,
      required this.resumeAudio});

  @override
  State<ExerciseItemWidget> createState() => _ExerciseItemWidgetState();
}

class _ExerciseItemWidgetState extends State<ExerciseItemWidget> {
  final _addFormKey = GlobalKey<FormState>();
  late String soundUrl;
  bool loadingAudio = false;
  Future? soundFuture;
  late String documentId;
  bool isPlaying = false;

  @override
  void initState() {
    soundUrl = widget.controller.soundUrl;
    if (soundUrl.isNotEmpty) {
      soundFuture = widget.setSourceUrl(soundUrl);
    }
    widget.onPlayerStateChanged.listen((event) {
      setState(() {
        loadingAudio = false;
        isPlaying = !isPlaying;
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
                    decoration: const InputDecoration(labelText: 'Sentence (use <f/> tag to add word placeholders)'),
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
                            'Solution'),
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
                      mime: const ['audio/mp3', 'audio/mp4'],
                      mimeErrorMessage: 'Only audio/mp3 and audio/mp3 allowed',
                      onFileUploaded: (String downloadUrl, String? thumbnailUrl) {
                        soundFuture = widget.setSourceUrl(downloadUrl);
                        setState(() {
                          soundUrl = downloadUrl;
                          widget.controller.soundUrl = soundUrl;
                        });
                      },
                    )
                  : Column(
                      children: [
                        if (loadingAudio)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        if (isPlaying)
                          IconButton(
                              onPressed: () {
                                widget.pauseAudio();
                              },
                              icon: const Icon(Icons.pause))
                        else
                          IconButton(
                              onPressed: () {
                                widget.resumeAudio();
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
