import 'package:flutter/cupertino.dart';
import 'package:data_forms/model/fields_model/field_model.dart';

class FormNumberModel extends FormFieldModel {
  int? maxLength;
  String? hint;
  bool? showCounter;

  FormNumberModel(
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
      weight,
      focusNode,
      showTitle,
      enableReadOnly,
      onTap,
      dependsOn,
      this.showCounter,
      this.maxLength,
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
