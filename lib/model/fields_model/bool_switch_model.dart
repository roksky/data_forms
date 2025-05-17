import 'package:data_forms/model/fields_model/field_model.dart';

class FormBoolSwitchModel extends FormFieldModel {
  FormBoolSwitchModel({
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
