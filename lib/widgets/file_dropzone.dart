import 'package:dotted_border/dotted_border.dart';
import 'package:drop_zone/drop_zone.dart';
import 'package:modern_turkmen_admin/widgets/progress_indicator_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../controllers/file_dropzone_controller.dart';

class FileDropzone extends StatefulWidget {
  const FileDropzone({
    Key? key,
    required this.label,
    required this.onDrop,
    required this.controller,
    this.fileType = 'image'
  }) : super(
      key: key
  );
  final String label;
  final dynamic Function(dynamic) onDrop;
  final FileDropzoneController controller;
  final String fileType;

  @override
  State<FileDropzone> createState() => _FileDropzoneState();
}

class _FileDropzoneState extends State<FileDropzone> {


  static const String _defaultStatusText = 'Drag and drop or click to select';
  String statusText = _defaultStatusText;
  String label = '';
  late FileDropzoneController controller;


  @override
  void initState() {
    label = widget.label;
    controller = widget.controller;
    controller.widget = widget;
    controller.onStatusChanged = () {
      setState(() {

      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectImage,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DropZone(
            onDragEnter: () {
              setState(() {
                label = 'Aaaaand... release!';
                statusText = 'Drop your file here';
              });
            },
            onDragExit: () {
              setState(() {
                label = widget.label;
                statusText = _defaultStatusText;
              });
            },
            onDrop: (files) {
              label = widget.label;
              statusText = _defaultStatusText;
              widget.onDrop(files);
            },
            child: DottedBorder(
              strokeWidth: controller.uploadStatus == 'idle' ? 3 : 0,
              dashPattern: const [11, 8],
              color: const Color(0xFFb3b5b9),
              child: Container(
                color: controller.uploadStatus == 'not-valid' ?
                const Color(0xFFffecec) : const Color(0xFFdedee0),
                height: 110,
                width: 500,
                constraints: const BoxConstraints(maxWidth: 500),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) =>
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(controller.uploadStatus == 'idle')
                            const Icon(Icons.upload_file),
                          if(controller.uploadStatus == 'running')
                            ProgressIndicatorWidget(
                                progress: controller.progress / 100,
                                isRunning: true
                            ),
                          if(controller.uploadStatus == 'not_valid')
                            const Icon(
                              Icons.error_outline, color: Color(0xFFc22301),),
                          if(controller.uploadStatus == 'success')
                            const Icon(Icons.check_circle_rounded, color: Color(
                                0xFF0670da
                            ),),
                          Text(
                            controller.uploadStatus == 'running' ?
                            'Uploading ${widget.fileType}... ${controller.progress.toInt()
                                .toString()}%' :
                            controller.uploadStatus == 'not_valid' ?
                            "That file isn't valid" :
                            controller.uploadStatus == 'success' ?
                            "Upload successful!" :
                            label,
                            style: TextStyle(
                                fontSize: 19,
                                color: controller.uploadStatus == 'not_valid' ?
                                const Color(0xFFc22301) : const Color(
                                    0xFF5c5e65)
                            ),),
                          Text(
                            controller.uploadStatus == 'running' ? controller
                                .filename! :
                            controller.uploadStatus ==
                                'not_valid' ? "Must be ${widget.fileType}" :
                            controller.uploadStatus == 'success' ? '' :
                            statusText,
                            style: TextStyle(
                                fontSize: 17,
                                color: controller.uploadStatus == 'not_valid' ?
                                const Color(0xFFc22301) : const Color(
                                    0xFF95969a)
                            ),
                          )
                        ],
                      ),
                ),
              ),
            )
        ),
      ),
    );
  }

  void selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      widget.onDrop(result.files);
    }
  }

}



