import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/enums/field_status.dart';
import 'package:data_forms/enums/filed_type.dart';
import 'package:data_forms/model/data_model/check_data_model.dart';
import 'package:data_forms/model/data_model/date_data_model.dart';
import 'package:data_forms/model/data_model/radio_data_model.dart';
import 'package:data_forms/model/data_model/spinner_data_model.dart';
import 'package:data_forms/model/fields_model/bank_card_filed_model.dart';
import 'package:data_forms/model/fields_model/checkbox_model.dart';
import 'package:data_forms/model/fields_model/date_picker_model.dart';
import 'package:data_forms/model/fields_model/date_range_picker_model.dart';
import 'package:data_forms/model/fields_model/email_model.dart';
import 'package:data_forms/model/fields_model/field_model.dart';
import 'package:data_forms/model/fields_model/image_picker_model.dart';
import 'package:data_forms/model/fields_model/location_model.dart';
import 'package:data_forms/model/fields_model/location_tree_model.dart';
import 'package:data_forms/model/fields_model/mobile_model.dart';
import 'package:data_forms/model/fields_model/multi_image_picker_model.dart';
import 'package:data_forms/model/fields_model/number_model.dart';
import 'package:data_forms/model/fields_model/price_model.dart';
import 'package:data_forms/model/fields_model/radio_model.dart';
import 'package:data_forms/model/fields_model/spinner_model.dart';
import 'package:data_forms/model/fields_model/text_filed_model.dart';
import 'package:data_forms/model/fields_model/text_password_model.dart';
import 'package:data_forms/model/fields_model/text_plain_model.dart';
import 'package:data_forms/model/fields_model/time_picker_model.dart';
import 'package:data_forms/model/fields_model/repeating_group_model.dart';
import 'package:data_forms/util/util.dart';
import 'package:data_forms/values/colors.dart';
import 'package:data_forms/values/theme.dart';
import 'package:data_forms/widget/fields/bank_card_field.dart';
import 'package:data_forms/widget/fields/check_list_field.dart';
import 'package:data_forms/widget/fields/date_picker_field.dart';
import 'package:data_forms/widget/fields/date_range_picker_field.dart';
import 'package:data_forms/widget/fields/email_field.dart';
import 'package:data_forms/widget/fields/image_picker_field.dart';
import 'package:data_forms/widget/fields/location_field.dart';
import 'package:data_forms/widget/fields/mobile_field.dart';
import 'package:data_forms/widget/fields/number_field.dart';
import 'package:data_forms/widget/fields/password_field.dart';
import 'package:data_forms/widget/fields/price_field.dart';
import 'package:data_forms/widget/fields/radio_group_field.dart';
import 'package:data_forms/widget/fields/spinner_field.dart';
import 'package:data_forms/widget/fields/text_field.dart';
import 'package:data_forms/widget/fields/text_plain_field.dart';
import 'package:data_forms/widget/fields/time_picker_field.dart';

import 'package:data_forms/enums/required_check_list_enum.dart';
import 'package:data_forms/model/data_model/location_item_model.dart';
import 'package:data_forms/model/fields_model/barcode_scanner_model.dart';
import 'package:data_forms/model/fields_model/bool_switch_model.dart';
import 'package:data_forms/model/fields_model/file_picker_model.dart';
import 'package:data_forms/model/fields_model/multi_media_picker_model.dart';
import 'package:data_forms/model/fields_model/qr_scanner_model.dart';
import 'package:data_forms/model/fields_model/signature_model.dart';
import 'package:data_forms/model/state_manager.dart';
import 'package:data_forms/widget/fields/barcode_scanner_field.dart';
import 'package:data_forms/widget/fields/bool_field.dart';
import 'package:data_forms/widget/fields/file_picker_field.dart';
import 'package:data_forms/widget/fields/location_tree_field.dart';
import 'package:data_forms/widget/fields/multi_image_picker_field.dart';
import 'package:data_forms/widget/fields/multi_media_picker_field.dart';
import 'package:data_forms/widget/fields/qr_scanner_field.dart';
import 'package:data_forms/widget/fields/signature_field.dart';
import 'package:data_forms/widget/fields/repeating_group_field.dart';

// ignore: must_be_immutable
class DataFormField extends StatefulWidget {
  FormFieldModel? model;
  Widget? child;
  FormStyle? formStyle;
  late StateManager stateManager;

  VoidCallback? onUpdate;

  void update() {
    onUpdate!.call();
  }

  DataFormField.qrScanner({
    super.key,
    required String tag,
    String? title,
    bool? showTitle,
    String? errorMessage,
    String? helpMessage,
    bool? required,
    FormFieldStatusEnum? status,
    int? weight,
    String? hint,
    Widget? iconWidget,
    Color? iconColor,
    bool? enableReadOnly,
  }) {
    model = FormQRScannerModel(
      type: FormFieldTypeEnum.qrScanner,
      tag: tag,
      showTitle: showTitle ?? false,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      iconWidget: iconWidget,
      enableReadOnly: enableReadOnly,
    );
  }

  DataFormField.imagePicker({
    super.key,
    required String tag,
    required Widget iconWidget,
    String? defaultImagePathValue,
    String? title,
    String? errorMessage,
    String? helpMessage,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    int? weight,
    String? hint,
    String? cameraPopupTitle,
    String? galleryPopupTitle,
    String? cameraPopupIcon,
    String? galleryPopupIcon,
    GSImageSource? imageSource,
    Color? iconColor,
    bool? showCropper,
    double? maximumSizePerImageInBytes,
    VoidCallback? onErrorSizeItem,
    String? dependsOn,
  }) {
    model = FormImagePickerModel(
      type: FormFieldTypeEnum.imagePicker,
      tag: tag,
      showCropper: showCropper ?? true,
      imageSource: imageSource ?? GSImageSource.both,
      showTitle: showTitle ?? false,
      title: title,
      cameraPopupTitle: cameraPopupTitle,
      galleryPopupTitle: galleryPopupTitle,
      cameraPopupIcon: cameraPopupIcon,
      galleryPopupIcon: galleryPopupIcon,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      iconWidget: iconWidget,
      value: defaultImagePathValue,
      maximumSizePerImageInBytes: maximumSizePerImageInBytes,
      onErrorSizeItem: onErrorSizeItem,
      dependsOn: dependsOn,
    );
  }

  DataFormField.multiImagePicker({
    super.key,
    required String tag,
    required Widget iconWidget,
    List<String>? defaultImagePathValues,
    String? title,
    String? errorMessage,
    String? helpMessage,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    int? weight,
    String? hint,
    String? cameraPopupTitle,
    String? galleryPopupTitle,
    String? cameraPopupIcon,
    String? galleryPopupIcon,
    GSImageSource? imageSource,
    Color? iconColor,
    bool? showCropper,
    double? maximumSizePerImageInKB,
    double? maximumImageCount,
    VoidCallback? onErrorSizeItem,
    String? dependsOn,
  }) {
    model = FormMultiImagePickerModel(
      type: FormFieldTypeEnum.multiImagePicker,
      tag: tag,
      showCropper: showCropper ?? true,
      imageSource: imageSource ?? GSImageSource.both,
      showTitle: showTitle ?? false,
      title: title,
      cameraPopupTitle: cameraPopupTitle,
      galleryPopupTitle: galleryPopupTitle,
      cameraPopupIcon: cameraPopupIcon,
      galleryPopupIcon: galleryPopupIcon,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      iconWidget: iconWidget,
      defaultImagePath: defaultImagePathValues,
      maximumImageCount: maximumImageCount,
      maximumSizePerImageInKB: maximumSizePerImageInKB,
      onErrorSizeItem: onErrorSizeItem,
      dependsOn: dependsOn,
    );
  }

  DataFormField.spinner({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    int? weight,
    RegExp? validateRegEx,
    SpinnerDataModel? value,
    ValueChanged<SpinnerDataModel?>? onChange,
    required List<SpinnerDataModel> items,
    String? hint,
    String? dependsOn,
  }) {
    model = FormSpinnerModel(
      type: FormFieldTypeEnum.spinner,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      required: required,
      status: status,
      weight: weight,
      items: items,
      hint: hint,
      onChange: onChange,
      value: value,
      dependsOn: dependsOn,
    );
  }

  DataFormField.radioGroup({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    int? weight,
    RegExp? validateRegEx,
    String? hint,
    Axis? scrollDirection,
    Widget? selectedIcon,
    Widget? unSelectedIcon,
    bool? scrollable,
    double? height,
    bool? showScrollBar,
    Color? scrollBarColor,
    required bool searchable,
    String? searchHint,
    Icon? searchIcon,
    BoxDecoration? searchBoxDecoration,
    required List<RadioDataModel> items,
    String? dependsOn,
    required ValueChanged<RadioDataModel> callBack,
  }) {
    model = FormRadioModel(
      type: FormFieldTypeEnum.radioGroup,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
      showScrollBar: showScrollBar,
      scrollBarColor: scrollBarColor,
      hint: hint,
      items: items,
      callBack: callBack,
      scrollDirection: scrollDirection,
      unSelectedIcon: unSelectedIcon,
      selectedIcon: selectedIcon,
      scrollable: scrollable ?? false,
      height: height,
      searchable: searchable,
      searchHint: searchHint,
      searchIcon: searchIcon,
      dependsOn: dependsOn,
      searchBoxDecoration: searchBoxDecoration,
    );
  }

  DataFormField.checkList({
    super.key,
    required String tag,
    required bool searchable,
    required List<CheckDataModel> items,
    required ValueChanged<CheckDataModel> callBack,
    RequiredCheckListEnum? requiredCheckListEnum,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    bool? showTitle,
    FormFieldStatusEnum? status,
    int? weight,
    RegExp? validateRegEx,
    String? hint,
    Axis? scrollDirection,
    Widget? selectedIcon,
    Widget? unSelectedIcon,
    bool? scrollable,
    double? height,
    bool? showScrollBar,
    Color? scrollBarColor,
    String? searchHint,
    Icon? searchIcon,
    BoxDecoration? searchBoxDecoration,
    String? dependsOn,
  }) {
    bool isRequired = false;
    if (requiredCheckListEnum != null &&
        requiredCheckListEnum != RequiredCheckListEnum.none) {
      isRequired = true;
    }
    model = FormCheckBoxModel(
      type: FormFieldTypeEnum.checkList,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: isRequired,
      status: status,
      weight: weight,
      showScrollBar: showScrollBar,
      scrollBarColor: scrollBarColor,
      hint: hint,
      items: items,
      callBack: callBack,
      scrollDirection: scrollDirection,
      unSelectedIcon: unSelectedIcon,
      selectedIcon: selectedIcon,
      scrollable: scrollable ?? false,
      height: height,
      searchable: searchable,
      searchHint: searchHint,
      searchIcon: searchIcon,
      searchBoxDecoration: searchBoxDecoration,
      dependsOn: dependsOn,
      requiredCheckListEnum: requiredCheckListEnum,
    );
  }

  DataFormField.text({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    int? minLine,
    int? maxLine,
    String? hint,
    bool? readOnly,
    FocusNode? focusNode,
    String? dependsOn,
    FocusNode? nextFocusNode,
  }) {
    model = FormTextModel(
      type: FormFieldTypeEnum.text,
      tag: tag,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      value: value,
      weight: weight,
      maxLength: maxLength,
      hint: hint,
      dependsOn: dependsOn,
      enableReadOnly: readOnly,
    );
  }

  DataFormField.password({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateReg,
    int? maxLength,
    int? minLine,
    int? maxLine,
    bool? isEnable,
    String? hint,
    bool? readOnly,
    String? dependsOn,
  }) {
    model = FormPasswordModel(
      type: FormFieldTypeEnum.password,
      showTitle: showTitle ?? true,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      required: required,
      status: status,
      value: value,
      weight: weight,
      hint: hint,
      maxLength: maxLength,
      enableReadOnly: readOnly,
      dependsOn: dependsOn,
    );
  }

  DataFormField.textPlain({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    int? minLine,
    int? maxLine,
    String? hint,
    bool? showCounter,
    bool? readOnly,
    String? dependsOn,
  }) {
    model = FormTextPlainModel(
      type: FormFieldTypeEnum.textPlain,
      tag: tag,
      title: title,
      showTitle: showTitle ?? true,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      value: value,
      weight: weight,
      hint: hint,
      maxLine: maxLine,
      minLine: minLine,
      maxLength: maxLength,
      showCounter: showCounter,
      enableReadOnly: readOnly,
      dependsOn: dependsOn,
    );
  }

  DataFormField.mobile({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    String? hint,
    bool? readOnly,
    String? dependsOn,
  }) {
    model = FormMobileModel(
      type: FormFieldTypeEnum.mobile,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      showTitle: showTitle ?? true,
      status: status,
      value: value,
      weight: weight,
      maxLength: maxLength,
      hint: hint,
      enableReadOnly: readOnly,
      dependsOn: dependsOn,
    );
  }

  DataFormField.number({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    bool? showTitle,
    bool? showCounter,
    String? hint,
    bool? readOnly,
    String? dependsOn,
  }) {
    model = FormNumberModel(
      type: FormFieldTypeEnum.number,
      showTitle: showTitle ?? true,
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
      maxLength: maxLength,
      hint: hint,
      showCounter: showCounter,
      enableReadOnly: readOnly,
      dependsOn: dependsOn,
    );
  }

  DataFormField.integer({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    FormFieldStatusEnum? status,
    int? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    bool? showTitle,
    bool? showCounter,
    String? hint,
    bool? readOnly,
  }) {
    model = FormNumberModel(
      type: FormFieldTypeEnum.integer,
      showTitle: showTitle ?? true,
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
      maxLength: maxLength,
      hint: hint,
      showCounter: showCounter,
      enableReadOnly: readOnly,
    );
  }

  DataFormField.double({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    FormFieldStatusEnum? status,
    double? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    bool? showTitle,
    bool? showCounter,
    String? hint,
    bool? readOnly,
  }) {
    model = FormNumberModel(
      type: FormFieldTypeEnum.double,
      showTitle: showTitle ?? true,
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
      maxLength: maxLength,
      hint: hint,
      showCounter: showCounter,
      enableReadOnly: readOnly,
    );
  }

  DataFormField.datePicker({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    int? weight,
    RegExp? validateReg,
    int? maxLength,
    String? hint,
    GSDateFormatType? displayDateType,
    bool? isPastAvailable,
    DataDate? initialDate,
    DataDate? availableFrom,
    DataDate? availableTo,
    String? dependsOn,
  }) {
    model = FormDatePickerModel(
      type: FormFieldTypeEnum.date,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      showTitle: showTitle ?? true,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      dependsOn: dependsOn,
      isPastAvailable: isPastAvailable,
      dateFormatType: displayDateType,
      initialDate: initialDate,
      availableFrom: availableTo,
      availableTo: availableTo,
    );
  }

  DataFormField.dateRangePicker({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    String? from,
    String? to,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    int? weight,
    RegExp? validateReg,
    int? maxLength,
    String? hint,
    GSDateFormatType? displayDateType,
    bool? isPastAvailable,
    DataDate? initialStartDate,
    DataDate? initialEndDate,
    DataDate? availableFrom,
    DataDate? availableTo,
    String? dependsOn,
  }) {
    model = FormDateRangePickerModel(
      type: FormFieldTypeEnum.dateRage,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      from: from ?? 'From ',
      to: to ?? 'To ',
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      showTitle: showTitle ?? true,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      isPastAvailable: isPastAvailable,
      dateFormatType: displayDateType,
      initialStartDate: initialStartDate,
      initialEndDate: initialEndDate,
      availableFrom: availableTo,
      availableTo: availableTo,
      dependsOn: dependsOn,
    );
  }

  DataFormField.time({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? showTitle,
    bool? required,
    FormFieldStatusEnum? status,
    int? weight,
    RegExp? validateReg,
    int? maxLength,
    String? hint,
    TimeOfDay? initialTime,
    String? dependsOn,
  }) {
    model = FormTimePickerModel(
      type: FormFieldTypeEnum.time,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      initialTime: initialTime,
      dependsOn: dependsOn,
    );
  }

  DataFormField.email({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    String? hint,
    bool? readOnly,
    String? dependsOn,
  }) {
    model = FormEmailModel(
      type: FormFieldTypeEnum.email,
      tag: tag,
      title: title,
      showTitle: showTitle ?? true,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      value: value,
      weight: weight,
      maxLength: maxLength,
      hint: hint,
      enableReadOnly: readOnly,
      dependsOn: dependsOn,
    );
  }

  DataFormField.price({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    String? currencyName,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    double? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    String? hint,
    bool? readOnly,
    String? dependsOn,
  }) {
    model = FormPriceModel(
      type: FormFieldTypeEnum.price,
      tag: tag,
      title: title,
      showTitle: showTitle ?? true,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: Text(
        currencyName ?? '',
        style: FormTheme.textThemeStyle.displaySmall,
      ),
      required: required,
      status: status,
      value: value,
      weight: weight,
      maxLength: maxLength,
      hint: hint,
      enableReadOnly: readOnly,
      dependsOn: dependsOn,
    );
  }

  DataFormField.bankCard({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? minLine,
    int? maxLine,
    String? dependsOn,
    String? hint,
  }) {
    model = FormBankCardModel(
      type: FormFieldTypeEnum.bankCard,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      showTitle: showTitle ?? true,
      value: value,
      weight: weight,
      hint: hint,
      dependsOn: dependsOn,
    );
  }

  DataFormField.filePicker({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    int? minLine,
    int? maxLine,
    String? hint,
    bool? readOnly,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    bool? allowMultiple,
    List<String>? allowedExtensions,
    FileType? fileType,
  }) {
    model = FormFilePickerModel(
      type: FormFieldTypeEnum.filePicker,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      value: value,
      weight: weight,
      hint: hint,
      allowMultiple: allowMultiple ?? true,
      fileType: fileType ?? FileType.any,
      allowedExtensions: allowedExtensions,
    );
  }

  DataFormField.multiMediaPicker({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    int? minLine,
    int? maxLine,
    String? hint,
    bool? readOnly,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) {
    model = FormMultiMediaPickerModel(
      type: FormFieldTypeEnum.multiMediaPicker,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
    );
  }

  DataFormField.signature({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    int? minLine,
    int? maxLine,
    String? hint,
    bool? readOnly,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    Widget? iconWidget,
    Color? color,
    bool fit = false,
  }) {
    model = FormSignatureModel(
      type: FormFieldTypeEnum.signature,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
      color: color ?? Colors.black,
      fit: fit,
      hint: hint,
      iconWidget: iconWidget,
    );
  }

  DataFormField.barcode({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    int? minLine,
    int? maxLine,
    String? hint,
    bool? readOnly,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) {
    model = FormBarCodeModel(
      type: FormFieldTypeEnum.barcode,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
    );
  }

  DataFormField.locationTree({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    int? weight,
    RegExp? validateRegEx,
    LocationItem? value,
    String? hint,
    String? targetLevel,
    String? dependsOn,
    required Future<List<LocationItem>> Function(String? parentId)
    fetchLocations,
    required Future<LocationItem?> Function(String locationId)
    fetchLocationById,
  }) {
    model = FormLocationTreeModel(
      type: FormFieldTypeEnum.locationTree,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      value: value,
      fetchLocations: fetchLocations,
      fetchLocationById: fetchLocationById,
      targetLevel: targetLevel,
      dependsOn: dependsOn,
    );
  }

  DataFormField.location({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    int? minLine,
    int? maxLine,
    String? hint,
    bool? readOnly,
    String? dependsOn,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) {
    model = FormLocationModel(
      type: FormFieldTypeEnum.location,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
      dependsOn: dependsOn,
    );
  }

  DataFormField.boolSwitch({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    bool? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    int? minLine,
    int? maxLine,
    String? hint,
    bool? readOnly,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) {
    model = FormBoolSwitchModel(
      type: FormFieldTypeEnum.boolean,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
    );
  }

  DataFormField.repeatingGroup({
    super.key,
    required String tag,
    required List<DataFormField> fields,
    String? title,
    String? errorMessage,
    String? helpMessage,
    bool? required,
    bool? showTitle,
    FormFieldStatusEnum? status,
    int? weight,
    int? minItems,
    int? maxItems,
    String? addButtonText,
    String? removeButtonText,
    bool? allowReorder,
    Widget? addIcon,
    Widget? removeIcon,
    Widget? reorderIcon,
    String? dependsOn,
  }) {
    model = FormRepeatingGroupModel(
      type: FormFieldTypeEnum.repeatingGroup,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      showTitle: showTitle ?? true,
      weight: weight,
      dependsOn: dependsOn,
      fields: fields,
      minItems: minItems,
      maxItems: maxItems,
      addButtonText: addButtonText,
      removeButtonText: removeButtonText,
      allowReorder: allowReorder ?? true,
      addIcon: addIcon,
      removeIcon: removeIcon,
      reorderIcon: reorderIcon,
    );
  }

  //</editor-fold>

  @override
  State<DataFormField> createState() => _GSFieldState();
}

class _GSFieldState extends State<DataFormField> {
  @override
  void didUpdateWidget(covariant DataFormField oldWidget) {
    _fillChild();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _fillChild();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.formStyle = widget.formStyle ?? FormStyle();
    widget.onUpdate = () {
      if (mounted) {
        if (widget.model?.status != FormFieldStatusEnum.disabled) {
          setState(() {});
        }
      }
    };

    return AbsorbPointer(
      absorbing: widget.model?.status == FormFieldStatusEnum.disabled,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Visibility(
                  visible: widget.model?.showTitle ?? false,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.model?.title ?? "",
                            style: widget.formStyle!.titleTextStyle,
                          ),
                          const SizedBox(width: 4.0),
                          Opacity(
                            opacity: widget.model?.required ?? false ? 1 : 0,
                            child: Text(
                              widget.formStyle!.requiredText,
                              style: const TextStyle(
                                color: FormColors.red,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                    ],
                  ),
                ),
                Container(
                  decoration: GSFormUtils.getFieldDecoration(
                    widget.formStyle!,
                    widget.model?.status,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible:
                            widget.model?.prefixWidget == null ? false : true,
                        child: Row(
                          children: [
                            const SizedBox(width: 8.0),
                            widget.model?.prefixWidget ??
                                const SizedBox(width: 0),
                            const SizedBox(width: 8.0),
                            Container(
                              height: 30.0,
                              color: FormColors.dividerColor,
                              width: 1.0,
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: widget.child!),
                      Visibility(
                        visible:
                            widget.model?.postfixWidget == null ? false : true,
                        child: Row(
                          children: [
                            const SizedBox(width: 10.0),
                            widget.model?.postfixWidget ??
                                const SizedBox(width: 0),
                            const SizedBox(width: 10.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0),
                Opacity(
                  opacity:
                      (widget.model?.status == FormFieldStatusEnum.error &&
                                  widget.model?.errorMessage != null) ||
                              widget.model?.helpMessage != null
                          ? 1
                          : 0,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 8.0,
                        height: 8.0,
                        child: SvgPicture.asset(
                          widget.model?.status == FormFieldStatusEnum.error
                              ? 'packages/data_forms/assets/ic_alert.svg'
                              : 'packages/data_forms/assets/ic_info.svg',
                        ),
                      ),
                      const SizedBox(width: 1.0),
                      Text(
                        widget.model?.status == FormFieldStatusEnum.error
                            ? widget.model?.errorMessage ?? ''
                            : widget.model?.helpMessage ?? '',
                        style:
                            widget.model?.status == FormFieldStatusEnum.error
                                ? widget.formStyle!.errorTextStyle
                                : widget.formStyle!.helpTextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _fillChild() {
    switch (widget.model?.type) {
      case FormFieldTypeEnum.text:
        widget.child = FormTextField(
          widget.model as FormTextModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.integer:
        widget.child = GSIntegerField(
          widget.model as FormNumberModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.double:
        widget.child = GSDoubleField(
          widget.model as FormNumberModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.number:
        widget.child = FormNumberField(
          widget.model as FormNumberModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.textPlain:
        widget.child = FormTextPlainField(
          widget.model as FormTextPlainModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.mobile:
        widget.child = FormMobileField(
          widget.model as FormMobileModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.password:
        widget.child = FormPasswordField(
          widget.model as FormPasswordModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.date:
        widget.child = FormDatePickerField(
          widget.model as FormDatePickerModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.dateRage:
        widget.child = FormDateRangePickerField(
          widget.model as FormDateRangePickerModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.time:
        widget.child = FormTimePickerField(
          widget.model as FormTimePickerModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.email:
        widget.child = FormEmailField(
          widget.model as FormEmailModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.price:
        widget.child = FormPriceField(
          widget.model as FormPriceModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.bankCard:
        widget.child = FormBankCardField(
          widget.model as FormBankCardModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.spinner:
        widget.child = FormSpinnerField(
          widget.model as FormSpinnerModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.radioGroup:
        widget.child = FormRadioGroupField(
          widget.model as FormRadioModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.checkList:
        widget.child = FormCheckListField(
          widget.model as FormCheckBoxModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.imagePicker:
        widget.child = FormImagePickerField(
          widget.model as FormImagePickerModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.qrScanner:
        widget.child = FormQRScannerField(
          widget.model as FormQRScannerModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.filePicker:
        widget.child = FormFilePickerField(
          widget.model as FormFilePickerModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.multiMediaPicker:
        widget.child = FormMultiMediaAttachmentField(
          widget.model as FormMultiMediaPickerModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.signature:
        widget.child = FormSignatureScreenField(
          widget.model as FormSignatureModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.multiImagePicker:
        widget.child = FormMultiImagePickerField(
          widget.model as FormMultiImagePickerModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.barcode:
        widget.child = FormBarcodeScannerField(
          widget.model as FormBarCodeModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.locationTree:
        widget.child = FormLocationTreeField(
          widget.model as FormLocationTreeModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.location:
        widget.child = FormLocationField(
          widget.model as FormLocationModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.boolean:
        widget.child = FormBoolSwitchField(
          widget.model as FormBoolSwitchModel,
          widget.formStyle!,
        );
        break;
      case FormFieldTypeEnum.repeatingGroup:
        widget.child = FormRepeatingGroupField(
          widget.model as FormRepeatingGroupModel,
          widget.formStyle!,
        );
        break;

      default:
        widget.child = Container();
    }
  }
}
