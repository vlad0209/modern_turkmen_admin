import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class Dropzone extends StatefulWidget {
  const Dropzone(
      {super.key,
      this.width,
      this.height,
      this.mime = const [
        'image/jpeg',
        'image/png',
      ],
      this.mimeErrorMessage,
      required this.auth,
      required this.onFileUploaded,
      required this.label,
      required this.storage});
  final double? width;
  final double? height;
  final void Function(String downloadUrl) onFileUploaded;
  final List<String> mime;
  final String? mimeErrorMessage;
  final String label;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  @override
  State<Dropzone> createState() => _DropzoneState();
}

class _DropzoneState extends State<Dropzone> {
  late DropzoneViewController controller;
  bool isHighlighted = false;
  bool isUploading = false;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    //When user click on the icon it also should upload file
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold),),
        DottedBorder(
          borderType: BorderType.RRect,
          strokeWidth: 2,
          //On error I want to show red color
          color: isError ? const Color(0xffF37A7A) : const Color(0xFFCED4DA),
          radius: const Radius.circular(8),
          dashPattern: const [8, 2],
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              //On hover I want to show light blue color
              color: isHighlighted
                  ? const Color(0xFFEBF0F7)
                  : isError
                      ? const Color(0xffFDEBEB)
                      : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                DropzoneView(
                  //On drop a callback will run
                  onDrop: acceptFile,
                  //On hover the box color will be change based on isHighlighted bool
                  onHover: () => setState(() => isHighlighted = true),
                  onLeave: () => setState(() => isHighlighted = false),
                  onCreated: (controller) => this.controller = controller,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isUploading
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.upload_file),
                      const SizedBox(height: 10),
                      TextButton(
                          onPressed: () async {
                            if (!isUploading) {
                              final ImagePicker picker = ImagePicker();
                              final canBeImage =
                                  widget.mime.any((type) => type.contains('image'));
                              final canBeVideo =
                                  widget.mime.any((type) => type.contains('video'));
                              XFile? file;
        
                              if (canBeImage && canBeVideo) {
                                file = await picker.pickMedia();
                              } else if (canBeImage) {
                                file = await picker.pickImage(
                                    source: ImageSource.gallery);
                              } else if (canBeVideo) {
                                file = await picker.pickVideo(
                                    source: ImageSource.gallery);
                              }
                              if (file != null) {
                                setState(() {
                                  isUploading = true;
                                  isHighlighted = false;
                                  isError = false;
                                });
                                uploadFile(file.name, await file.readAsBytes());
                              }
                            }
                          },
                          child: const Text('Click here')),
                      const Text(
                        'or drag to this area to upload',
                      ),
                      if (isError)
                        Text(
                          widget.mimeErrorMessage ?? 'Only images allowed',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: const Color(0xffF37A7A)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> acceptFile(dynamic event) async {
    
    setState(() {
      isUploading = true;
      isHighlighted = false;
      isError = false;
    });
    final bytes = await controller.getFileData(event);
    
    // Get the current user
    final user = widget.auth.currentUser;
    if (user == null) {
      if (kDebugMode) {
        print('User not logged in');
      }
      setState(() {
        isUploading = false;
      });
      return;
    }
    final fileName = await controller.getFilename(event);

    // Firebase upload
    uploadFile(fileName, bytes);
  }

  Future<void> uploadFile(localFileName, bytes) async {
    try {
      // Check file type
      final mimeType = lookupMimeType(localFileName);
      if (kDebugMode) {
        print("Mime type: $mimeType");
      }
      if (!widget.mime.contains(mimeType)) {
        setState(() {
          isUploading = false;
          isError = true;
        });
        return;
      }
      final user = widget.auth.currentUser;
      final ext = localFileName.split('.').last;
      var time = DateTime.now().millisecondsSinceEpoch.toString();
      final ref =
          widget.storage.ref().child('uploads').child(user!.uid).child('$time.$ext');
      final uploadTask =
          ref.putData(bytes, SettableMetadata(contentType: mimeType));
      
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      

      widget.onFileUploaded(downloadUrl);

      setState(() {
        isUploading = false;
      });
    } catch (e) {
      setState(() {
        isUploading = false;
        isError = true;
        if (kDebugMode) {
          print(e);
        }
      });
    }
    setState(() {});
  }

  Future<bool> fileExists(String file) async {
    var parts = file.split('/');
    var path = parts.sublist(0, parts.length - 1).join('/');
    var listResult = await widget.storage.ref().child(path).list();
    return listResult.items.any((element) => element.fullPath == file);
  }
}
