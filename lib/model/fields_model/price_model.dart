import 'package:flutter/cupertino.dart';

import 'package:data_forms/model/fields_model/field_model.dart';

class FormPriceModel extends FormFieldModel {
  int? maxLength;

  String? hint;

  FormPriceModel(
      {type,
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
      maxLength,
      weight,
      showTitle,
      enableReadOnly,
      onTap,
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
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: FocusNode(),
          showTitle: showTitle,
          enableReadOnly: enableReadOnly,
          onTap: onTap,
          dependsOn: dependsOn,
        );
}
