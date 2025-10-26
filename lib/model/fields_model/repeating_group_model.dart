import 'package:flutter/material.dart';
import 'package:data_forms/model/fields_model/field_model.dart';

class FormRepeatingGroupModel extends FormFieldModel {
  List<FormFieldModel> fields;
  int? minItems;
  int? maxItems;
  String? addButtonText;
  String? removeButtonText;
  bool allowReorder;
  Widget? addIcon;
  Widget? removeIcon;
  Widget? reorderIcon;

  FormRepeatingGroupModel({
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
    validateRegEx,
    weight,
    showTitle,
    enableReadOnly,
    onTap,
    focusNode,
    nextFocusNode,
    dependsOn,
    required this.fields,
    this.minItems,
    this.maxItems,
    this.addButtonText,
    this.removeButtonText,
    this.allowReorder = true,
    this.addIcon,
    this.removeIcon,
    this.reorderIcon,
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
         validateRegEx: validateRegEx,
         weight: weight,
         focusNode: focusNode,
         nextFocusNode: nextFocusNode,
         showTitle: showTitle,
         enableReadOnly: enableReadOnly,
         onTap: onTap,
         dependsOn: dependsOn,
       );

  /// Creates a copy of this model with new field instances
  FormRepeatingGroupModel copyForNewGroup(int groupIndex) {
    List<FormFieldModel> copiedFields = fields.map((field) => _copyFieldModel(field, groupIndex)).toList();
    
    return FormRepeatingGroupModel(
      type: type,
      tag: '${tag}_$groupIndex',
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
      showTitle: showTitle,
      enableReadOnly: enableReadOnly,
      onTap: onTap,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      dependsOn: dependsOn,
      fields: copiedFields,
      minItems: minItems,
      maxItems: maxItems,
      addButtonText: addButtonText,
      removeButtonText: removeButtonText,
      allowReorder: allowReorder,
      addIcon: addIcon,
      removeIcon: removeIcon,
      reorderIcon: reorderIcon,
    );
  }

  /// Helper method to copy field model with new tag
  FormFieldModel _copyFieldModel(FormFieldModel field, int groupIndex) {
    // This is a basic copy - you may need to implement specific copying logic
    // for each field type based on your field model implementations
    field.tag = '${field.tag}_$groupIndex';
    return field;
  }
}