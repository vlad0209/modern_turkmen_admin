import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:modern_turkmen_admin/widgets/dropzone.dart';

class TutorialForm extends StatefulWidget {
  final String action;
  final Function onSuccess;
  final Function onFail;
  final String? id;
  final Map? data;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  const TutorialForm(
      {super.key,
      required this.action,
      required this.onSuccess,
      required this.onFail,
      this.id,
      this.data,
      required this.auth,
      required this.firestore,
      required this.storage});

  @override
  State<TutorialForm> createState() => _TutorialFormState();
}

class _TutorialFormState extends State<TutorialForm> {
  final TextEditingController _englishNameController = TextEditingController();
  final TextEditingController _russianNameController = TextEditingController();
  final HtmlEditorController _englishContentController = HtmlEditorController();
  final HtmlEditorController _russianContentController = HtmlEditorController();

  String requestStatus = 'idle';
  final _formKey = GlobalKey<FormState>();
  DateTime? updatedAt;
  bool publicEn = false;
  bool publicRu = false;
  String image = '';
  late String tutorialId;

  @override
  void initState() {
    if (widget.data != null) {
      _englishNameController.text = widget.data!['title_en'] ?? '';
      _russianNameController.text = widget.data!['title_ru'] ?? '';
      updatedAt = widget.data!['updated_at']?.toDate();
      publicEn = widget.data!['public_en'] ?? false;
      publicRu = widget.data!['public_ru'] ?? false;
      image = widget.data!['image_url'] ?? '';
      tutorialId = widget.id!;
    } else {
      tutorialId = widget.firestore.collection('tutorials').doc().id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 11),
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'English Name'),
                        controller: _englishNameController,
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
                        decoration:
                            const InputDecoration(labelText: 'Russian Name'),
                        controller: _russianNameController,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 11),
                        child: Row(
                          children: [
                            const Text('English content:'),
                            IconButton(
                                onPressed: () {
                                  _englishContentController.toggleCodeView();
                                },
                                icon: const Icon(Icons.code))
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 11),
                      child: HtmlEditor(
                        htmlEditorOptions: HtmlEditorOptions(
                          hint: 'Enter English Content',
                          initialText: widget.data != null
                              ? widget.data!['content_en']
                              : '',
                        ),
                        otherOptions: const OtherOptions(
                          height: 400,
                        ),
                        controller: _englishContentController,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 11),
                        child: Row(
                          children: [
                            const Text('Russian content:'),
                            IconButton(
                                onPressed: () {
                                  _russianContentController.toggleCodeView();
                                },
                                icon: const Icon(Icons.code))
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 11),
                      child: HtmlEditor(
                        htmlEditorOptions: HtmlEditorOptions(
                          hint: 'Enter Russian Content',
                          initialText: widget.data != null
                              ? widget.data!['content_ru']
                              : '',
                        ),
                        otherOptions: const OtherOptions(
                          height: 400,
                        ),
                        controller: _russianContentController,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 11),
                        child: image.isEmpty
                            ? Dropzone(
                                storage: widget.storage,
                                auth: widget.auth,
                                label: 'Upload image of the tutorial',
                                onFileUploaded: (String downloadUrl) {
                                  setState(() {
                                    image = downloadUrl;
                                  });
                                },
                              )
                            : Column(
                                children: [
                                  Image.network(image),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          image = '';
                                        });
                                      },
                                      child: const Text('Replace the image'))
                                ],
                              )),
                    Container(
                      margin: const EdgeInsets.only(top: 11),
                      child: Row(
                        children: [
                          Checkbox(
                            value: publicEn,
                            onChanged: (bool? value) {
                              setState(() {
                                publicEn = value!;
                              });
                            },
                          ),
                          const Text('Public in English')
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 11),
                      child: Row(
                        children: [
                          Checkbox(
                            value: publicRu,
                            onChanged: (bool? value) {
                              setState(() {
                                publicRu = value!;
                              });
                            },
                          ),
                          const Text('Public in Russian')
                        ],
                      ),
                    ),
                    if (updatedAt != null)
                      Container(
                          margin: const EdgeInsets.only(top: 11),
                          child: Text(
                              'Updated at: ${DateFormat('yyyy-MM-dd – kk:mm').format(updatedAt!)}')),
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
        'title_en': _englishNameController.text,
        'title_ru': _russianNameController.text,
        'content_en': await _englishContentController.getText(),
        'content_ru': await _russianContentController.getText(),
        'updated_at': Timestamp.now(),
        'public_en': publicEn,
        'public_ru': publicRu,
        'image_url': image,
      };

      try {
        if (widget.action == 'create') {
          data['created_at'] = Timestamp.now();
          await widget.firestore.collection('tutorials').add(data);
        } else if (widget.action == 'update') {
          await widget.firestore
              .collection('tutorials')
              .doc(tutorialId)
              .update(data);
        }
        widget.onSuccess(tutorialId);
      } on Exception catch (exception) {
        widget.onFail(exception);
      }

      setState(() {
        requestStatus = 'idle';
        updatedAt = data['updated_at'].toDate();
      });
    }
  }
}
