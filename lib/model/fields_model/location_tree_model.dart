import 'package:data_forms/model/data_model/location_item_model.dart';
import 'package:data_forms/model/fields_model/field_model.dart';
import 'package:flutter/cupertino.dart';

class FormLocationTreeModel extends FormFieldModel {
  int? maxLength;

  String? hint;
  List<String> hierarchy = ['COUNTRY', 'REGION', 'AREA', 'TERRITORY', 'OUTLET'];
  Future<List<LocationItem>> Function(String? parentId) fetchLocations;
  Future<LocationItem?> Function(String locationId) fetchLocationById;

  String? targetLevel;

  FormLocationTreeModel(
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
      maxLength,
      weight,
      showTitle,
      enableReadOnly,
      dependsOn,
      this.targetLevel,
      required this.fetchLocations,
      required this.fetchLocationById,
      onTap,
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
          weight: weight,
          focusNode: FocusNode(),
          showTitle: showTitle,
          enableReadOnly: enableReadOnly,
          onTap: onTap,
          dependsOn: dependsOn,
        );
}
