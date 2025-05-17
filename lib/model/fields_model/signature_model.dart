import 'package:flutter/material.dart';

import 'package:data_forms/model/fields_model/field_model.dart';

class FormSignatureModel extends FormFieldModel {
  String? hint;
  Widget? iconWidget;
  Color color;
  bool fit;

  FormSignatureModel({
    type,
    tag,
    title,
    errorMessage,
    helpMessage,
    required,
    status,
    weight,
    showTitle,
    this.hint,
    this.iconWidget,
    this.color = Colors.black,
    this.fit = false,
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
       );
}
