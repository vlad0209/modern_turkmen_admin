import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/dropzone_view_model.dart';

class Dropzone extends ConsumerStatefulWidget {
  const Dropzone(
      {super.key,
      this.width,
      this.height,
      this.mime = const [
        'image/jpeg',
        'image/png',
      ],
      this.mimeErrorMessage,
      required this.onFileUploaded,
      this.multiple = false,
      required this.label});
  final double? width;
  final double? height;
  final void Function(String downloadUrl, String? thumbnailUrl) onFileUploaded;
  final List<String> mime;
  final String? mimeErrorMessage;
  final String label;
  final bool multiple;

  @override
  ConsumerState<Dropzone> createState() => _DropzoneState();
}

class _DropzoneState extends ConsumerState<Dropzone> {
  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(dropzoneViewModelProvider(widget.mime, widget.multiple));
    final viewModel = ref.read(dropzoneViewModelProvider(widget.mime, widget.multiple).notifier);
    //When user click on the icon it also should upload file
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        DottedBorder(
          borderType: BorderType.RRect,
          strokeWidth: 2,
          //On error I want to show red color
          color: uiState.isError ? const Color(0xffF37A7A) : const Color(0xFFCED4DA),
          radius: const Radius.circular(8),
          dashPattern: const [8, 2],
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height ?? 180,
            decoration: BoxDecoration(
              //On hover I want to show light blue color
              color: uiState.isHighlighted
                  ? const Color(0xFFEBF0F7)
                  : uiState.isError
                      ? const Color(0xffFDEBEB)
                      : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                DropzoneView(
                  //On drop a callback will run
                  onDrop: _acceptFile,
                  //On hover the box color will be change based on isHighlighted bool
                  onHover: () => viewModel.setIsHighlighted(true),
                  onLeave: () => viewModel.setIsHighlighted(false),
                  onCreated: (controller) => viewModel.setController(controller),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      uiState.isUploading
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.upload_file),
                      const SizedBox(height: 10),
                      TextButton(
                          onPressed: _pickFile,
                          child: const Text('Click here')),
                      const Text(
                        'or drag to this area to upload',
                      ),
                      if (uiState.isError)
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

  Future<void> _pickFile() async {
    await ref.read(dropzoneViewModelProvider(widget.mime, widget.multiple).notifier).pickFile(widget.onFileUploaded);
  }

  Future<void> _acceptFile(dynamic event) async {
    await ref
        .read(dropzoneViewModelProvider(widget.mime, widget.multiple).notifier)
        .acceptFile(event, widget.onFileUploaded);
  }
}