import 'package:flutter/material.dart';
import 'package:data_forms/model/fields_model/field_model.dart';

import '../../widget/field.dart';

class FormRepeatingGroupModel extends FormFieldModel {
  List<DataFormField> fields;
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

  FormRepeatingGroupModel copyForNewGroup(String groupId) {
    List<DataFormField> copiedFields = fields
        .map((field) => _copyFieldModel(field, groupId))
        .toList();

    return FormRepeatingGroupModel(
      type: type,
      tag: '${tag}_$groupId',
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

  DataFormField _copyFieldModel(DataFormField field, String groupId) {
    field.model!.tag = '${field.model!.tag}_$groupId';
    return field;
  }
}
