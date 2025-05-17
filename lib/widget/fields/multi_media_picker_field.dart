import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/multi_media_picker_model.dart';
import 'package:data_forms/util/video_thumbnail.dart';
import 'notifyable_stateful_widget.dart';

class FormMultiMediaAttachmentField
    extends NotifiableStatefulWidget<List<Attachment>> {
  late FormMultiMediaPickerModel model;
  final FormStyle formStyle;

  FormMultiMediaAttachmentField(this.model, this.formStyle, {super.key});
  final List<Attachment> _attachments = [];

  @override
  State<FormMultiMediaAttachmentField> createState() =>
      _GSMultiMediaAttachmentFieldState();

  @override
  FormFieldValue<List<Attachment>> getValue() {
    return FormFieldValue.attachments(_attachments);
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return (_attachments).isNotEmpty;
    }
  }
}

class _GSMultiMediaAttachmentFieldState
    extends State<FormMultiMediaAttachmentField> {
  void _pickFiles() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.media);
    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (file.extension == 'jpg' ||
              file.extension == 'jpeg' ||
              file.extension == 'png') {
            widget._attachments.add(Attachment(
                filePath: file.path!, fileType: AttachmentFileType.image));
          } else if (file.extension == 'mp4' ||
              file.extension == 'avi' ||
              file.extension == 'mov') {
            widget._attachments.add(Attachment(
                filePath: file.path!, fileType: AttachmentFileType.video));
          }
        }
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      widget._attachments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // Set the scroll direction to horizontal
              itemCount: widget._attachments.length + 1,
              // Number of items in the list
              itemBuilder: (context, index) {
                return index == 0
                    ? SelectItem(
                        model: widget.model,
                        onTap: _pickFiles,
                      )
                    : SizedBox(
                        width: 90,
                        height: 90, // Set a fixe
                        child: MediaPreview(
                          widget._attachments[index - 1],
                          (attachment) => _removeAttachment(index - 1),
                        ),
                      );
              },
            ),
          ),
          SizedBox(height: 10),
          widget._attachments.isNotEmpty
              ? Text("You have selected ${widget._attachments.length} files")
              : Text('No files attached'),
        ],
      ),
    );
  }
}

class SelectItem extends StatelessWidget {
  const SelectItem({required this.model, required this.onTap, super.key});

  final FormMultiMediaPickerModel model;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        child: model.iconWidget ??
            Icon(Icons.attachment, color: Colors.black, size: 85),
      ),
    );
  }
}

class MediaPreview extends StatelessWidget {
  final Attachment attachment;
  final Function(Attachment attachement) onTap;

  const MediaPreview(this.attachment, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(attachment),
      child: Card(
        child: attachment.fileType == AttachmentFileType.image
            ? Image.file(
                File(attachment.filePath),
                fit: BoxFit.cover,
              )
            : VideoThumbnailWithPlayButton(attachment.filePath),
      ),
    );
  }
}

class VideoThumbnailWithPlayButton extends StatelessWidget {
  final String filePath;

  const VideoThumbnailWithPlayButton(this.filePath, {super.key});

  Future<String> _getThumbnail(String videoPath) async {
    final tempDir = await getTemporaryDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 128,
      // specify the width of the thumbnail, the height will be auto-scaled to match
      quality: 25,
    );
    return thumbnailPath!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getThumbnail(filePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Image.file(
                File(snapshot.data!),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Attachment {
  final String filePath;
  final AttachmentFileType fileType;

  Attachment({required this.filePath, required this.fileType});
}

enum AttachmentFileType { image, video }
