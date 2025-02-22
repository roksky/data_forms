import 'package:flutter/material.dart';

import 'field_model.dart';

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
    value,
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
          value: value,
          validateRegEx: validateReg,
          weight: weight,
          showTitle: showTitle,
          dependsOn: dependsOn,
        );
}
