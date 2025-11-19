import 'package:flutter/material.dart';
import 'package:modern_turkmen_admin/ui/exercises/widgets/exercise_item.dart';

import '../../../domain/models/exercise/exercise.dart';

class ExerciseForm extends StatefulWidget {
  final String action;
  final Function onSuccess;
  final Function onFail;
  final String? id;
  final String tutorialId;
  final String languageCode;
  final Exercise? exercise;
  final Function setSourceUrl;
  final Stream<void> onPlayerStateChanged;
  final Function pauseAudio;
  final Function resumeAudio;
  final Future<String> Function(Map<String, dynamic>) createExercise;
  final Future<void> Function(Map<String, dynamic>) updateExercise;

  const ExerciseForm(
      {super.key,
      required this.action,
      required this.onSuccess,
      required this.onFail,
      required this.tutorialId,
      required this.languageCode,
      required this.setSourceUrl,
      required this.onPlayerStateChanged,
      required this.pauseAudio,
      required this.resumeAudio,
      required this.createExercise,
      required this.updateExercise,
      this.id,
      this.exercise});

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  final TextEditingController _exampleTranslationController =
      TextEditingController();

  Future<dynamic>? _pendingRequest;
  final _formKey = GlobalKey<FormState>();
  List items = [];

  final _orderNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.exercise != null) {
      _orderNumberController.text =
          widget.exercise!.orderNumber?.toString() ?? '0';
      _descriptionController.text = widget.exercise!.description ?? '';
      _exampleController.text = widget.exercise!.example ?? '';
      _exampleTranslationController.text =
          widget.exercise!.exampleTranslation ?? '';
      int itemIndex = 0;
      items = widget.exercise!.items!.map((item) {
        itemIndex++;
        Key key = Key('item_$itemIndex');
        return ExerciseItemWidget(
          key: key,
          onRemove: () {
            setState(() {
              items.removeWhere((item) => item.key == key);
            });
          },
          controller: ExerciseItemController(
            soundUrl: item.sound ?? '',
            options: item.options.join(','),
            sentence: item.sentence,
            solution: item.solution,
            translation: item.translation,
          ),
          setSourceUrl: widget.setSourceUrl,
          onPlayerStateChanged: widget.onPlayerStateChanged,
          pauseAudio: widget.pauseAudio,
          resumeAudio: widget.resumeAudio,
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(11),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 11),
                    width: 70,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Order number',
                          border: OutlineInputBorder()),
                      controller: _orderNumberController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 11),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder()),
                      controller: _descriptionController,
                      minLines: 8,
                      maxLines: 11,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 11),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText:
                              'Example (use <f></f> tag to add word tags)',
                          border: OutlineInputBorder()),
                      controller: _exampleController,
                      minLines: 8,
                      maxLines: 11,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 11),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Example translation',
                          border: OutlineInputBorder()),
                      controller: _exampleTranslationController,
                      minLines: 8,
                      maxLines: 11,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 11),
                    child: const Text(
                      'Items',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: [
                      Column(
                        children: items.cast(),
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      IconButton(
                        onPressed: addItem,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 11),
                    child: FutureBuilder(
                        future: _pendingRequest,
                        builder: (context, asyncSnapshot) {
                          return ElevatedButton(
                              onPressed: () =>
                                  asyncSnapshot.connectionState !=
                                          ConnectionState.waiting
                                      ? submitForm()
                                      : null,
                              child: asyncSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Save'));
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'order_number': int.tryParse(_orderNumberController.text) ?? 0,
        'description': _descriptionController.text,
        'example': _exampleController.text,
        'example_translation': _exampleTranslationController.text,
        'items': items
            .map((item) => {
                  'options': item.controller.options
                      .split(',')
                      .map((e) => e.trim())
                      .toList(),
                  'sentence': item.controller.sentence,
                  'solution': item.controller.solution,
                  'sound': item.controller.soundUrl,
                  'translation': item.controller.translation
                })
            .toList()
      };

      try {
        if (widget.action == 'create') {
          setState(() {
            _pendingRequest = widget.createExercise(data);
          });
        } else if (widget.action == 'update') {
          setState(() {
            _pendingRequest = widget.updateExercise(data);
          });
        }
        String exerciseId;
        if (widget.action == 'create') {
          exerciseId = await _pendingRequest as String;
        } else {
          exerciseId = widget.id!;
          await _pendingRequest;
        }
        widget.onSuccess(widget.tutorialId, exerciseId);
      } on Exception catch (exception) {
        widget.onFail(exception);
      }
    }
  }

  void addItem() {
    final controller = ExerciseItemController(
        soundUrl: '', options: '', sentence: '', solution: '', translation: '');
    setState(() {
      Key key = Key('item_${items.length + 1}');
      items.add(ExerciseItemWidget(
        key: key,
        onRemove: () {
          setState(() {
            items.removeWhere((item) => item.key == key);
          });
        },
        controller: controller,
        setSourceUrl: widget.setSourceUrl,
        onPlayerStateChanged: widget.onPlayerStateChanged,
        pauseAudio: widget.pauseAudio,
        resumeAudio: widget.resumeAudio,
      ));
    });
  }
}
