import 'package:data_forms/model/data_model/spinner_data_model.dart';
import 'package:data_forms/model/fields_model/field_model.dart';
import 'package:flutter/cupertino.dart';

class FormSpinnerModel extends FormFieldModel {
  List<SpinnerDataModel> items;
  String? hint;
  ValueChanged<SpinnerDataModel?>? onChange;

  FormSpinnerModel(
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
      onTap,
      showTitle,
      dependsOn,
      required this.items,
      this.onChange,
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
          showTitle: showTitle,
          dependsOn: dependsOn,
        );
}
