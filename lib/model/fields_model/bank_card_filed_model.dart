import 'package:flutter/material.dart';

import 'field_model.dart';

class GSBankCardModel extends GSFieldModel {
  String? hint;

  GSBankCardModel(
      {type,
      tag,
      title,
      errorMessage,
      helpMessage,
      prefixWidget,
      postfixWidget,
      required,
      status,
      value,
      validateRegEx,
      weight,
      showTitle,
      enableReadOnly,
      dependsOn,
      this.hint})
      : super(
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
          value: value,
          validateRegEx: validateRegEx,
          weight: weight,
          enableReadOnly: enableReadOnly,
          focusNode: FocusNode(),
          dependsOn: dependsOn,
        );
}
