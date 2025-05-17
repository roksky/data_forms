import 'package:flutter/cupertino.dart';

import 'package:data_forms/enums/field_status.dart';
import 'package:data_forms/enums/filed_type.dart';

abstract class FormFieldModel {
  FormFieldTypeEnum? type;
  String? title;
  String tag;
  String? dependsOn;
  String? errorMessage;
  String? helpMessage;
  Widget? prefixWidget;
  Widget? postfixWidget;
  bool? required;
  bool? showTitle;
  FormFieldStatusEnum status;
  RegExp? validateRegEx;
  int? weight;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  dynamic value;
  bool? enableReadOnly;
  VoidCallback? onTap;

  FormFieldModel({
    this.type,
    required this.tag,
    this.dependsOn,
    this.showTitle,
    this.title,
    this.errorMessage,
    this.helpMessage,
    this.prefixWidget,
    this.postfixWidget,
    this.required,
    this.value,
    this.validateRegEx,
    this.weight,
    this.focusNode,
    this.nextFocusNode,
    this.onTap,
    FormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : status = status ?? FormFieldStatusEnum.normal,
       enableReadOnly = enableReadOnly ?? false;
}
