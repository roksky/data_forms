import 'package:flutter/cupertino.dart';

import 'package:data_forms/enums/field_status.dart';
import 'package:data_forms/enums/filed_type.dart';
import 'package:data_forms/rules/form_rule.dart';

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

  /// Field-level visibility rules.
  ///
  /// These are merged with any form-level rules supplied to [DataForm].
  /// Each rule's [FormRule.target] is automatically set to [tag] when the
  /// rules are registered with the engine, so you may leave it blank here.
  List<FormRule>? rules;

  /// Set at runtime by the rules engine.
  ///
  /// `true`  → this field is currently hidden due to a rule evaluation.
  /// `false` → this field is visible (default).
  bool isHiddenByRule;

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
    this.rules,
    FormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : status = status ?? FormFieldStatusEnum.normal,
       enableReadOnly = enableReadOnly ?? false,
       isHiddenByRule = false;
}
