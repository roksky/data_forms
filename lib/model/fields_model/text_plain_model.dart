import 'package:flutter/cupertino.dart';

import 'package:data_forms/model/fields_model/field_model.dart';

class FormTextPlainModel extends FormFieldModel {
  int? maxLength;
  int? maxLine;
  int? minLine;
  String? hint;
  bool? showCounter;

  FormTextPlainModel({
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
    enableReadOnly,
    weight,
    showTitle,
    onTap,
    dependsOn,
    this.minLine,
    this.maxLength,
    this.maxLine,
    this.hint,
    this.showCounter,
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
         validateRegEx: validateRegEx,
         weight: weight,
         focusNode: FocusNode(),
         showTitle: showTitle,
         enableReadOnly: enableReadOnly,
         onTap: onTap,
         dependsOn: dependsOn,
       );
}
