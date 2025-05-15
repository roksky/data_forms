import 'dart:io';

import 'package:flutter/material.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/image_picker_model.dart';
import 'package:data_forms/util/util.dart';
import 'package:data_forms/values/colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:data_forms/widget/squircle/smooth_border_radius.dart';
import 'package:data_forms/widget/squircle/smooth_radius.dart';
import 'notifyable_stateful_widget.dart';

// ignore: must_be_immutable
class FormImagePickerField extends NotifiableStatefulWidget<String> {
  final FormImagePickerModel model;
  final FormStyle formStyle;

  FormImagePickerField(this.model, this.formStyle, {Key? key})
      : super(key: key);
  String? _croppedFilePath;

  @override
  State<FormImagePickerField> createState() => _GSImagePickerFieldState();

  @override
  FormFieldValue<String> getValue() {
    return FormFieldValue.filePath(_croppedFilePath);
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return _croppedFilePath != null;
    }
  }
}

class _GSImagePickerFieldState extends State<FormImagePickerField> {
  @override
  void initState() {
    super.initState();
    if (widget.model.value != null) {
      widget._croppedFilePath = widget.model.value;
    } else {
      widget._croppedFilePath = null;
    }
  }

  @override
  void didUpdateWidget(covariant FormImagePickerField oldWidget) {
    if (widget.model.value != null) {
      widget._croppedFilePath = widget.model.value;
    } else {
      widget._croppedFilePath = oldWidget._croppedFilePath;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onTap: () {
          if (widget.model.imageSource == GSImageSource.both) {
            GSFormUtils.showImagePickerBottomSheet(
              cameraName: widget.model.cameraPopupTitle,
              galleryName: widget.model.galleryPopupTitle,
              cameraAssets: widget.model.cameraPopupIcon,
              galleryAssets: widget.model.galleryPopupIcon,
              context,
              (image) async {
                _fillImagePath(image);
              },
            );
          } else if (widget.model.imageSource == GSImageSource.camera) {
            GSFormUtils.pickImage(ImageSource.camera).then(
              (imageFile) {
                if (imageFile != null) {
                  _fillImagePath(imageFile);
                }
              },
            );
          } else {
            GSFormUtils.pickImage(ImageSource.gallery).then(
              (imageFile) {
                if (imageFile != null) {
                  _fillImagePath(imageFile);
                }
              },
            );
          }
        },
        child: widget._croppedFilePath == null
            ? NormalView(model: widget.model, formStyle: widget.formStyle)
            : ImagePickedView(
                croppedFilePath: widget._croppedFilePath!,
                model: widget.model,
                formStyle: widget.formStyle,
                onDeleteImage: () {
                  widget._croppedFilePath = null;
                  setState(() {});
                }),
      ),
    );
  }

  _fillImagePath(File image) {
    if (widget.model.showCropper ?? false) {
      _cropImage(image);
    } else {
      setState(() {});
      if (widget.model.maximumSizePerImageInBytes != null) {
        if (image.lengthSync() / 1000 <
            widget.model.maximumSizePerImageInBytes!) {
          widget._croppedFilePath = image.path;
        } else {
          widget.model.onErrorSizeItem?.call();
        }
      } else {
        widget._croppedFilePath = image.path;
      }
    }
  }

  Future<void> _cropImage(File image) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'ویرایش تصویر',
            toolbarColor: FormColors.white,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        if (widget.model.maximumSizePerImageInBytes != null) {
          if (image.lengthSync() / 1000 <
              widget.model.maximumSizePerImageInBytes!) {
            widget._croppedFilePath = image.path;
          } else {
            widget.model.onErrorSizeItem?.call();
          }
        } else {
          widget._croppedFilePath = image.path;
        }
      });
    }
  }
}

class NormalView extends StatelessWidget {
  const NormalView({required this.model, required this.formStyle, Key? key})
      : super(key: key);
  final FormImagePickerModel model;
  final FormStyle formStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          model.iconWidget,
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: model.required ?? false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4, left: 4),
                  child: Text(
                    formStyle.requiredText,
                    style: const TextStyle(
                      color: FormColors.red,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              Text(
                model.title ?? '',
                style: formStyle.titleTextStyle,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(
            model.hint ?? '',
            style: formStyle.fieldHintStyle,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ImagePickedView extends StatelessWidget {
  String croppedFilePath;
  final FormImagePickerModel model;
  final FormStyle formStyle;
  final VoidCallback onDeleteImage;

  ImagePickedView(
      {required this.croppedFilePath,
      Key? key,
      required this.model,
      required this.formStyle,
      required this.onDeleteImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(File(croppedFilePath), fit: BoxFit.contain),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 32.0,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: SmoothBorderRadius.only(
                    bottomLeft: SmoothRadius(
                      cornerRadius: 11.0,
                      cornerSmoothing: 1,
                    ),
                    bottomRight: SmoothRadius(
                      cornerRadius: 11.0,
                      cornerSmoothing: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        model.title!,
                        style: formStyle.titleTextStyle
                            .copyWith(color: Colors.white),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 20.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            onDeleteImage.call();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                'حذف',
                                maxLines: 1,
                                style: formStyle.titleTextStyle
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
