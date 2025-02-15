import 'package:flutter/cupertino.dart';

import 'field_model.dart';

class GSLocationModel extends GSFieldModel {
  String? hint;
  Widget? iconWidget;

  GSLocationModel({
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
