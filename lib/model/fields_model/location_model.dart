import 'package:flutter/cupertino.dart';

import 'package:data_forms/model/fields_model/field_model.dart';

class FormLocationModel extends FormFieldModel {
  String? hint;
  Widget? iconWidget;

  FormLocationModel({
    type,
    tag,
    title,
    errorMessage,
    helpMessage,
    required,
    status,
    weight,
    showTitle,
    dependsOn,
    this.hint,
    this.iconWidget,
  }) : super(
         type: type,
         tag: tag,
         title: title,
         errorMessage: errorMessage,
         helpMessage: helpMessage,
         required: required,
         status: status,
         weight: weight,
         dependsOn: dependsOn,
         showTitle: showTitle,
       );
}
