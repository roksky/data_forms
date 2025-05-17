class SpinnerDataModel {
  String name;
  int id;
  bool? isSelected;
  dynamic data;
  dynamic spinnerValue;

  SpinnerDataModel({
    required this.name,
    required this.id,
    this.data,
    bool? isSelected,
    this.spinnerValue,
  }) : isSelected = isSelected ?? false;
}
