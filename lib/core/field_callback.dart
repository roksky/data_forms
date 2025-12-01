import 'package:file_picker/file_picker.dart';

import '../model/data_model/check_data_model.dart';
import '../model/data_model/date_data_model.dart';
import '../model/data_model/location_item_model.dart';
import '../model/data_model/radio_data_model.dart';
import '../model/data_model/spinner_data_model.dart';
import '../model/response/position_response.dart';
import '../widget/fields/multi_media_picker_field.dart';

abstract class FormFieldCallBack<T> {
  bool isValid();

  FormFieldValue<T> getValue();
}

class FormFieldValue<T> {
  FormFieldValue(this.value, this.valueType);

  FormFieldValue.string(String? value)
    : value = value as T?,
      valueType = FormFieldValueType.string;

  FormFieldValue.int(int? value)
    : value = value as T?,
      valueType = FormFieldValueType.int;

  FormFieldValue.double(double? value)
    : value = value as T?,
      valueType = FormFieldValueType.double;

  FormFieldValue.bool(bool? value)
    : value = value as T?,
      valueType = FormFieldValueType.bool;

  FormFieldValue.dateTime(DateTime? value)
    : value = value as T?,
      valueType = FormFieldValueType.dateTime;

  FormFieldValue.date(DateTime? value)
    : value = value as T?,
      valueType = FormFieldValueType.date;

  FormFieldValue.filePath(String? value)
    : value = value as T?,
      valueType = FormFieldValueType.filePath;

  FormFieldValue.checkDataList(List<CheckDataModel> value)
    : value = value as T,
      valueType = FormFieldValueType.checkDataList;

  FormFieldValue.radioData(RadioDataModel? value)
    : value = value as T?,
      valueType = FormFieldValueType.radioData;

  FormFieldValue.spinnerData(SpinnerDataModel? value)
    : value = value as T?,
      valueType = FormFieldValueType.spinnerData;

  FormFieldValue.platFormFiles(List<PlatformFile> value)
    : value = value as T,
      valueType = FormFieldValueType.platFormFile;

  FormFieldValue.filePaths(List<String> value)
    : value = value as T,
      valueType = FormFieldValueType.filePathList;

  FormFieldValue.position(PositionResponse? value)
    : value = value as T?,
      valueType = FormFieldValueType.position;

  FormFieldValue.locationItem(LocationItem? value)
    : value = value as T?,
      valueType = FormFieldValueType.locationItem;

  FormFieldValue.attachments(List<Attachment> value)
    : value = value as T,
      valueType = FormFieldValueType.attachments;

  FormFieldValue.dateData(DateDataModel? value)
    : value = value as T?,
      valueType = FormFieldValueType.dateData;

  FormFieldValue.dateDataRange(DateDataRangeModel? value)
    : value = value as T?,
      valueType = FormFieldValueType.dateDataRange;

  FormFieldValue.repeatingGroup(List<Map<String, dynamic>> value)
    : value = value as T,
      valueType = FormFieldValueType.repeatingGroup;

  T? value;
  FormFieldValueType valueType;
}

// an enum of all the possible value types
enum FormFieldValueType {
  string,
  int,
  double,
  bool,
  dateTime,
  date,
  checkDataList,
  radioData,
  spinnerData,
  dateData,
  dateDataRange,
  platFormFile,
  filePath,
  filePathList,
  position,
  locationItem,
  attachments,
  repeatingGroup,
}
