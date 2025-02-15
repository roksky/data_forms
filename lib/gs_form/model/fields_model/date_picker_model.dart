import 'package:data_forms/gs_form/model/fields_model/field_model.dart';

import '../data_model/date_data_model.dart';

class GSDatePickerModel extends GSFieldModel {
  String? hint;
  GSDateFormatType? dateFormatType;
  bool? isPastAvailable;
  GSDate? initialDate;
  GSDate? availableFrom;
  GSDate? availableTo;

  GSDatePickerModel({
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
    weight,
    showTitle,
    dependsOn,
    this.hint,
    this.dateFormatType,
    this.isPastAvailable,
    this.availableFrom,
    this.availableTo,
    this.initialDate,
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
            weight: weight,
            dependsOn: dependsOn,
            showTitle: showTitle);
}
