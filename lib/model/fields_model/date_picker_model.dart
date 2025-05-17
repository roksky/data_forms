import 'package:data_forms/model/data_model/date_data_model.dart';
import 'package:data_forms/model/fields_model/field_model.dart';

class FormDatePickerModel extends FormFieldModel {
  String? hint;
  GSDateFormatType? dateFormatType;
  bool? isPastAvailable;
  DataDate? initialDate;
  DataDate? availableFrom;
  DataDate? availableTo;

  FormDatePickerModel({
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
            weight: weight,
            dependsOn: dependsOn,
            showTitle: showTitle);
}
