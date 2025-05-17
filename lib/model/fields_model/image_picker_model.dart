import 'package:flutter/material.dart';

import 'package:data_forms/model/fields_model/field_model.dart';

class FormImagePickerModel extends FormFieldModel {
  String? hint;
  Widget iconWidget;
  String? cameraPopupTitle;
  String? galleryPopupTitle;
  String? cameraPopupIcon;
  String? galleryPopupIcon;
  GSImageSource? imageSource;
  bool? showCropper;
  double? maximumSizePerImageInBytes;
  VoidCallback? onErrorSizeItem;

  FormImagePickerModel({
    type,
    tag,
    title,
    errorMessage,
    helpMessage,
    required,
    status,
    weight,
    showTitle,
    super.value,
    dependsOn,
    required this.iconWidget,
    this.cameraPopupIcon,
    this.galleryPopupIcon,
    this.showCropper,
    this.cameraPopupTitle,
    this.galleryPopupTitle,
    this.imageSource,
    this.hint,
    this.maximumSizePerImageInBytes,
    this.onErrorSizeItem,
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

enum GSImageSource { camera, gallery, both }
