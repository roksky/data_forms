import 'package:flutter/material.dart';
import 'package:data_forms/model/data_model/radio_data_model.dart';

import 'package:data_forms/model/fields_model/field_model.dart';

class FormRadioModel extends FormFieldModel {
  List<RadioDataModel> items;
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
  final ValueChanged<RadioDataModel> callBack;

  FormRadioModel({
    type,
    tag,
    title,
    errorMessage,
    helpMessage,
    required,
    status,
    super.value,
    weight,
    showTitle,
    dependsOn,
    required this.items,
    required this.callBack,
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
         weight: weight,
         showTitle: showTitle,
         dependsOn: dependsOn,
       );
}
