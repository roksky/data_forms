// ignore_for_file: must_be_immutable

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/file_picker_model.dart';
import 'notifyable_stateful_widget.dart';

class FormFilePickerField extends NotifiableStatefulWidget implements FormFieldCallBack {
  late FormFilePickerModel model;
  final FormStyle formStyle;

  FormFilePickerField(this.model, this.formStyle, {Key? key}) : super(key: key);
  List<PlatformFile> _files = [];

  @override
  State<FormFilePickerField> createState() => _GSFilePickerFieldState();

  @override
  getValue() {
    return _files;
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return (_files).isNotEmpty;
    }
  }
}

class _GSFilePickerFieldState extends State<FormFilePickerField> {
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: widget.model.allowMultiple,
      type: widget.model.fileType,
      allowedExtensions: widget.model.allowedExtensions,
    );

    if (result != null) {
      setState(() {
        widget._files = result.files;
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      widget._files.removeAt(index);
    });
  }

  @override
  Widget build1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _pickFiles,
              child: Text(widget.model.hint ?? 'Attach Files'),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget._files.length,
            itemBuilder: (context, index) {
              final file = widget._files[index];
              return GestureDetector(
                onTap: () => _removeAttachment(index),
                child: FilePreview(file, (file) => _removeAttachment(index)),
              );
            },
          ),
          SizedBox(height: 10),
          Center(
            child: widget._files.isNotEmpty
                ? Text("You have selected ${widget._files.length} files")
                : Text('No files attached'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _pickFiles,
              child: Text(widget.model.hint ?? 'Attach Files'),
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // Set the scroll direction to horizontal
              itemCount: widget._files.length,
              // Number of items in the list
              itemBuilder: (context, index) {
                final attachment = widget._files[index];
                return SizedBox(
                  width: 90,
                  height: 90, // Set a fixe
                  child: FilePreview(
                    attachment,
                    (attachment) => _removeAttachment(index),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          widget._files.isNotEmpty
              ? Text("You have selected ${widget._files.length} files")
              : Text('No files attached'),
        ],
      ),
    );
  }
}

class FilePreview extends StatelessWidget {
  final PlatformFile file;
  final Function(PlatformFile file) onTap;

  FilePreview(this.file, this.onTap);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: GestureDetector(
        onTap: () => onTap(file),
        child: Card(
          child: Center(
              child: Column(
            children: [
              _getFileIcon(file.extension ?? ''),
              Text(file.name, style: TextStyle(fontSize: 10)),
            ],
          )),
        ),
      ),
    );
  }

  Icon _getFileIcon(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icon(Icons.image, size: 45);
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'mkv':
        return Icon(Icons.videocam, size: 45);
      case 'pdf':
        return Icon(Icons.picture_as_pdf, size: 45);
      case 'doc':
      case 'docx':
        return Icon(Icons.description, size: 45);
      default:
        return Icon(Icons.insert_drive_file, size: 45);
    }
  }
}
