class TimeDataModel {
  String displayTime;

  int hour;

  int minute;

  TimeDataModel({
    required this.displayTime,
    required this.hour,
    required this.minute,
  });

  // Represent as 24hr format HH:mm
  @override
  String toString() {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
