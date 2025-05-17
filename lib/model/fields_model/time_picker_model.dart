import 'package:flutter/material.dart';

import 'package:data_forms/model/fields_model/field_model.dart';

class FormTimePickerModel extends FormFieldModel {
  String? hint;
  TimeOfDay? initialTime;

  FormTimePickerModel({
    type,
    tag,
    title,
    errorMessage,
    helpMessage,
    prefixWidget,
    postfixWidget,
    required,
    status,
    super.value,
    validateReg,
    weight,
    showTitle,
    dependsOn,
    this.hint,
    this.initialTime,
  }) : super(
         type: type,
         tag: tag,
         title: title,
         errorMessage: errorMessage,
         helpMessage: helpMessage,
         prefixWidget: prefixWidget,
         postfixWidget: postfixWidget,
         required: required,
         status: status,
         validateRegEx: validateReg,
         weight: weight,
         showTitle: showTitle,
         dependsOn: dependsOn,
       );
}
