import 'package:flutter/material.dart';
import 'package:data_forms/model/fields_model/field_model.dart';

class FormColorPickerModel extends FormFieldModel {
  List<Color>? colors;

  FormColorPickerModel({
    super.type,
    required super.tag,
    super.title,
    super.errorMessage,
    super.helpMessage,
    super.required,
    super.status,
    super.weight,
    super.showTitle,
    super.enableReadOnly,
    super.value,
    super.dependsOn,
    this.colors,
  });
}
