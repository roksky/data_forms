import 'package:data_forms/model/data_model/date_data_model.dart';
import 'package:data_forms/model/fields_model/field_model.dart';

class FormDateRangePickerModel extends FormFieldModel {
  String? hint;
  GSDateFormatType? dateFormatType;
  bool? isPastAvailable;
  DataDate? initialStartDate;
  DataDate? initialEndDate;
  DataDate? availableFrom;
  DataDate? availableTo;
  String? from;
  String? to;

  FormDateRangePickerModel({
    type,
    tag,
    title,
    errorMessage,
    helpMessage,
    showTitle,
    prefixWidget,
    postfixWidget,
    required,
    status,
    value,
    validateReg,
    weight,
    dependsOn,
    this.hint,
    this.dateFormatType,
    this.isPastAvailable,
    this.availableFrom,
    this.availableTo,
    this.initialStartDate,
    this.initialEndDate,
    this.from,
    this.to,
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
            dependsOn: dependsOn,
            showTitle: showTitle);
}
