import 'package:data_forms/model/fields_model/field_model.dart';

class FormTextModel extends FormFieldModel {
  int? maxLength;

  String? hint;

  FormTextModel(
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
      onTap,
      focusNode,
      nextFocusNode,
      dependsOn,
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
          value: value,
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          showTitle: showTitle,
          enableReadOnly: enableReadOnly,
          onTap: onTap,
          dependsOn: dependsOn,
        );
}
