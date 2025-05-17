import 'package:flutter/material.dart';

import 'package:data_forms/model/fields_model/field_model.dart';

class FormBankCardModel extends FormFieldModel {
  String? hint;

  FormBankCardModel({
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
    validateRegEx,
    weight,
    showTitle,
    enableReadOnly,
    dependsOn,
    this.hint,
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
         showTitle: showTitle,
         validateRegEx: validateRegEx,
         weight: weight,
         enableReadOnly: enableReadOnly,
         focusNode: FocusNode(),
         dependsOn: dependsOn,
       );
}
