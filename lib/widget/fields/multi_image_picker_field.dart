import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/image_picker_model.dart';
import 'package:data_forms/util/util.dart';
import 'package:data_forms/values/colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:data_forms/model/fields_model/multi_image_picker_model.dart';
import 'notifyable_stateful_widget.dart';

// ignore: must_be_immutable
class FormMultiImagePickerField extends NotifiableStatefulWidget<List<String>> {
  final FormMultiImagePickerModel model;
  final FormStyle formStyle;

  FormMultiImagePickerField(this.model, this.formStyle, {super.key});
  List<String> _croppedFilePaths = [];

  @override
  State<FormMultiImagePickerField> createState() =>
      _GSMultiImagePickerFieldState();

  @override
  FormFieldValue<List<String>> getValue() {
    return FormFieldValue.filePaths(_croppedFilePaths);
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return (_croppedFilePaths).isNotEmpty;
    }
  }
}

class _GSMultiImagePickerFieldState extends State<FormMultiImagePickerField> {
  @override
  void initState() {
    super.initState();
    if ((widget.model.defaultImagePath ?? []).isNotEmpty) {
      widget._croppedFilePaths.addAll(widget.model.defaultImagePath ?? []);
    } else {
      widget._croppedFilePaths = [];
    }
  }

  @override
  void didUpdateWidget(covariant FormMultiImagePickerField oldWidget) {
    if ((widget.model.defaultImagePath ?? []).isNotEmpty) {
      widget._croppedFilePaths.addAll(widget.model.defaultImagePath ?? []);
    } else {
      widget._croppedFilePaths = [];
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: widget._croppedFilePaths.length + 1,
        itemBuilder: (context, index) {
          return index == 0
              ? SelectItem(
                  model: widget.model,
                  style: widget.formStyle,
                  isEnable: _enableSelectImageButton(),
                  callBack: (imagePath) {
                    widget._croppedFilePaths.add(imagePath);
                    setState(() {});
                  },
                )
              : ImageBox(
                  imagePath: widget._croppedFilePaths[index - 1],
                  onDelete: (value) {
                    widget._croppedFilePaths.removeWhere(
                      (element) => element == value,
                    );
                    setState(() {});
                  },
                );
        },
      ),
    );
  }

  bool _enableSelectImageButton() {
    if (widget.model.maximumImageCount != null) {
      if (widget._croppedFilePaths.length >= widget.model.maximumImageCount!) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}

class SelectItem extends StatelessWidget {
  const SelectItem({
    required this.model,
    required this.style,
    required this.callBack,
    required this.isEnable,
    super.key,
  });

  final FormMultiImagePickerModel model;
  final FormStyle style;
  final ValueChanged<String> callBack;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AbsorbPointer(
        absorbing: !isEnable,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.black45, width: 1),
          ),
          height: 90,
          width: 90,
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onTap: () {
              if (model.imageSource == GSImageSource.both) {
                GSFormUtils.showImagePickerBottomSheet(
                  cameraName: model.cameraPopupTitle,
                  galleryName: model.galleryPopupTitle,
                  cameraAssets: model.cameraPopupIcon,
                  galleryAssets: model.galleryPopupIcon,
                  context,
                  (image) async {
                    _fillImagePath(image);
                  },
                );
              } else if (model.imageSource == GSImageSource.camera) {
                GSFormUtils.pickImage(ImageSource.camera).then((imageFile) {
                  if (imageFile != null) {
                    _fillImagePath(imageFile);
                  }
                });
              } else {
                GSFormUtils.pickImage(ImageSource.gallery).then((imageFile) {
                  if (imageFile != null) {
                    _fillImagePath(imageFile);
                  }
                });
              }
            },
            child: Container(
              color: isEnable ? Colors.transparent : Colors.black45,
              child: model.iconWidget,
            ),
          ),
        ),
      ),
    );
  }

  _fillImagePath(File image) {
    if (model.showCropper ?? false) {
      _cropImage(image);
    } else {
      if (model.maximumSizePerImageInKB != null) {
        if (image.lengthSync() / 1000 < model.maximumSizePerImageInKB!) {
          callBack.call(image.path);
        } else {
          model.onErrorSizeItem?.call();
        }
      } else {
        callBack.call(image.path);
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
          toolbarTitle: 'Edit Image',
          toolbarColor: FormColors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );
    if (croppedFile != null) {
      if (model.maximumSizePerImageInKB != null) {
        if (image.lengthSync() / 1000 < model.maximumSizePerImageInKB!) {
          model.onErrorSizeItem?.call();
        } else {
          callBack.call(image.path);
        }
      } else {
        callBack.call(image.path);
      }
    }
  }
}

class ImageBox extends StatelessWidget {
  const ImageBox({super.key, required this.imagePath, required this.onDelete});
  final String imagePath;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
            clipBehavior: Clip.hardEdge,
            child: imagePath.contains('http')
                ? Image.network(
                    imagePath,
                    width: 90,
                    height: 90,
                    fit: BoxFit.fill,
                  )
                : Image.file(
                    File(imagePath),
                    width: 90,
                    height: 90,
                    fit: BoxFit.fill,
                  ),
          ),
          Positioned(
            bottom: 8.0,
            left: 8.0,
            child: InkWell(
              onTap: () {
                onDelete.call(imagePath);
              },
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: SvgPicture.asset(
                  'packages/data_forms/assets/ic_trash.svg',
                  height: 15,
                  width: 15,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
