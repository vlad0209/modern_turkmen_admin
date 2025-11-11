import 'package:flutter/material.dart';
import 'package:modern_turkmen_admin/domain/models/tutorial/tutorial.dart';
import 'package:modern_turkmen_admin/ui/core/ui/dropzone.dart';

class TutorialForm extends StatefulWidget {
  final String action;
  final Function onSuccess;
  final Function onFail;
  final String? id;
  final Tutorial? tutorial;
  final Future<String> Function(Map<String, dynamic>) addTutorial;
  final Future Function(Map<String, dynamic>) updateTutorial;

  const TutorialForm(
      {super.key,
      required this.action,
      required this.onSuccess,
      required this.onFail,
      required this.addTutorial,
      required this.updateTutorial,
      this.id,
      this.tutorial,});

  @override
  State<TutorialForm> createState() => _TutorialFormState();
}

class _TutorialFormState extends State<TutorialForm> {
  final TextEditingController _englishNameController = TextEditingController();
  final TextEditingController _russianNameController = TextEditingController();
  final TextEditingController _englishContentController =
      TextEditingController();
  final TextEditingController _russianContentController = TextEditingController();

  Future<dynamic>? _pendingRequest;
  final _formKey = GlobalKey<FormState>();
  bool publicEn = false;
  bool publicRu = false;
  String image = '';
  String thumb = '';
  String? tutorialId;

  @override
  void initState() {
    if (widget.tutorial != null) {
      _englishNameController.text = widget.tutorial!.titleEn;
      _russianNameController.text = widget.tutorial!.titleRu;
      _englishContentController.text = widget.tutorial!.contentEn ?? '';
      _russianContentController.text = widget.tutorial!.contentRu ?? '';
      publicEn = widget.tutorial!.publicEn;
      publicRu = widget.tutorial!.publicRu;
      image = widget.tutorial!.imageUrl ?? '';
      thumb = widget.tutorial!.thumbUrl ?? '';
      tutorialId = widget.id!;
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
                      child: TextFormField(
                        maxLines: 10,
                        decoration:
                            const InputDecoration(labelText: 'English Content'),
                        controller: _englishContentController,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 11),
                      child: TextFormField(
                        maxLines: 10,
                        decoration:
                            const InputDecoration(labelText: 'Russian Content'),
                        controller: _russianContentController,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 11),
                        child: image.isEmpty
                            ? Dropzone(
                                label: 'Upload image of the tutorial',
                                onFileUploaded: (String downloadUrl, String? thumbnailUrl) {
                                  setState(() {
                                    image = downloadUrl;
                                    thumb = thumbnailUrl ?? '';
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
                    Container(
                      margin: const EdgeInsets.only(top: 11),
                      child: FutureBuilder(
                        future: _pendingRequest,
                        builder: (context, asyncSnapshot) {
                          return ElevatedButton(
                              onPressed: () => asyncSnapshot.connectionState == ConnectionState.waiting ? null : submitForm(),
                              child: asyncSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Save'));
                        }
                      ),
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

    if (_formKey.currentState!.validate()) {
      
      Map<String, dynamic> data = {
        'title_en': _englishNameController.text,
        'title_ru': _russianNameController.text,
        'content_en': _englishContentController.text,
        'content_ru': _russianContentController.text,
        'public_en': publicEn,
        'public_ru': publicRu,
        'image_url': image,
        'thumb_url': thumb,
      };

      try {
        if (widget.action == 'create') {
          data['created_at'] = DateTime.now();
          setState(() {
            _pendingRequest = widget.addTutorial(data);
          });
        } else if (widget.action == 'update') {
          setState(() {
            _pendingRequest = widget.updateTutorial(data);
          });
        }
        final newTutorialId = await _pendingRequest;
        widget.onSuccess(newTutorialId ?? tutorialId);
      } on Exception catch (exception) {
        widget.onFail(exception);
      }
    }
  }
}
