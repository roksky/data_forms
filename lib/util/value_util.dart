import 'package:data_forms/model/data_model/spinner_data_model.dart';

dynamic getValue(dynamic value) {
  if (value == null) {
    return null;
  } else if (value is SpinnerDataModel) {
    return value.spinnerValue;
  }

  return value;
}
