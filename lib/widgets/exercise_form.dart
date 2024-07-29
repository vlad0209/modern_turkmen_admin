import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modern_turkmen_admin/widgets/exercise_item.dart';

class ExerciseForm extends StatefulWidget {
  final String action;
  final Function onSuccess;
  final Function onFail;
  final String? id;
  final String tutorialId;
  final String languageCode;
  final Map? data;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  const ExerciseForm(
      {super.key,
      required this.action,
      required this.onSuccess,
      required this.onFail,
      required this.tutorialId,
      required this.languageCode,
      this.id,
      this.data,
      required this.auth,
      required this.firestore,
      required this.storage});

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  final TextEditingController _exampleTranslationController =
      TextEditingController();

  String requestStatus = 'idle';
  final _formKey = GlobalKey<FormState>();
  List items = [];
  
  final _orderNumberController = TextEditingController();

  @override
  void initState() {
    if (widget.data != null) {
      _orderNumberController.text = widget.data!['order_number']?.toString() ?? '0';
      _descriptionController.text = widget.data!['description'];
      _exampleController.text = widget.data!['example'];
      _exampleTranslationController.text =
          widget.data!['example_translation'] ?? '';
      int itemIndex = 0;
      items = widget.data!['items'].map((item) {
        itemIndex++;
        Key key = Key('item_$itemIndex');
        return ExerciseItem(
          key: key,
          onRemove: () {
            setState(() {
              items.removeWhere((item) => item.key == key);
            });
          },
          controller: ExerciseItemController(
            soundUrl: item['sound'],
            options: item['options'].join(','),
            sentence: item['sentence'],
            solution: item['solution'],
            translation: item['translation'],
          ),
          auth: widget.auth, storage: widget.storage,
        );
      }).toList();
    }
    super.initState();
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
            Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Form(
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
                      child: ElevatedButton(
                          onPressed: submitForm,
                          child: requestStatus == 'pending'
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Save')),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitForm() async {
    if (requestStatus == 'pending') {
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        requestStatus = 'pending';
      });

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
        String? exerciseId;
        if (widget.action == 'create') {
          final exercise = await widget.firestore
              .collection('tutorials/${widget.tutorialId}'
                  '/exercises_${widget.languageCode}')
              .add(data);
          exerciseId = exercise.id;
        } else if (widget.action == 'update') {
          await widget.firestore
              .collection(
                  'tutorials/${widget.tutorialId}/exercises_${widget.languageCode}')
              .doc(widget.id)
              .set(data);
          exerciseId = widget.id;
        }
        if (exerciseId != null) {
          widget.onSuccess(widget.tutorialId, exerciseId);
        }
      } on Exception catch (exception) {
        widget.onFail(exception);
      }

      setState(() {
        requestStatus = 'idle';
      });
    }
  }

  void addItem() {
    final controller = ExerciseItemController(
        soundUrl: '', options: '', sentence: '', solution: '', translation: '');
    setState(() {
      Key key = Key('item_${items.length + 1}');
      items.add(ExerciseItem(
        key: key,
        onRemove: () {
          setState(() {
            items.removeWhere((item) => item.key == key);
          });
        },
        controller: controller,
        auth: widget.auth, storage: widget.storage,
      ));
    });
  }
}
