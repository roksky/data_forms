import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:data_forms/model/fields_model/field_model.dart';

class FormFilePickerModel extends FormFieldModel {
  String? hint;
  bool allowMultiple;
  List<String>? allowedExtensions;
  FileType fileType;

  FormFilePickerModel({
    type,
    tag,
    title,
    errorMessage,
    helpMessage,
    required,
    status,
    weight,
    showTitle,
    value,
    required this.allowMultiple,
    required this.fileType,
    this.hint,
    this.allowedExtensions,
  }) : super(
            type: type,
            tag: tag,
            title: title,
            errorMessage: errorMessage,
            helpMessage: helpMessage,
            required: required,
            status: status,
            weight: weight,
            showTitle: showTitle,
            value: value);
}

enum GSPickerType { single, multiple }
