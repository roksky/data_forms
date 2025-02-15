import 'package:flutter/material.dart';
import 'package:data_forms/enums/required_check_list_enum.dart';
import 'package:data_forms/model/data_model/check_data_model.dart';

import 'field_model.dart';

class GSCheckBoxModel extends GSFieldModel {
  List<CheckDataModel> items;
  String? hint;
  Widget? selectedIcon;
  Widget? unSelectedIcon;
  bool? scrollable;
  double? height;
  Axis? scrollDirection;
  bool? showScrollBar;
  bool searchable;
  String? searchHint;
  Icon? searchIcon;
  BoxDecoration? searchBoxDecoration;
  Color? scrollBarColor;
  RequiredCheckListEnum? requiredCheckListEnum;

  final ValueChanged<CheckDataModel> callBack;

  GSCheckBoxModel({
    type,
    tag,
    title,
    errorMessage,
    helpMessage,
    required,
    status,
    value,
    weight,
    showTitle,
    enableReadOnly,
    dependsOn,
    required this.items,
    required this.callBack,
    this.requiredCheckListEnum,
    this.selectedIcon,
    this.unSelectedIcon,
    this.hint,
    this.scrollable,
    this.height,
    this.scrollDirection,
    this.scrollBarColor,
    this.showScrollBar,
    required this.searchable,
    this.searchHint,
    this.searchIcon,
    this.searchBoxDecoration,
  }) : super(
          type: type,
          tag: tag,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          required: required,
          status: status,
          value: value,
          weight: weight,
          showTitle: showTitle,
          enableReadOnly: enableReadOnly,
          dependsOn: dependsOn,
        );
}
