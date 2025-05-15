import 'package:data_forms/model/data_model/location_item_model.dart';
import 'package:data_forms/model/data_model/spinner_data_model.dart';

dynamic getValue(dynamic value) {
  if (value == null) {
    return null;
  } else if (value is SpinnerDataModel) {
    return value.spinnerValue;
  }

  return value;
}

dynamic getLocationValue(dynamic value) {
  if (value == null) {
    return null;
  } else if (value is SpinnerDataModel) {
    return LocationItem(id: value.spinnerValue, name: value.name);
  }

  return value;
}
