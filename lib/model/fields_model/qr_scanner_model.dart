import 'package:flutter/cupertino.dart';

import 'package:data_forms/model/fields_model/field_model.dart';

class FormQRScannerModel extends FormFieldModel {
  String? hint;
  Widget? iconWidget;

  FormQRScannerModel({
    type,
    tag,
    title,
    errorMessage,
    helpMessage,
    required,
    status,
    weight,
    showTitle,
    enableReadOnly,
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
          showTitle: showTitle,
          enableReadOnly: enableReadOnly,
        );
}
