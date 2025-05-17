import 'package:geolocator/geolocator.dart';

class PositionResponse {
  final double latitude;
  final double longitude;

  PositionResponse({required this.latitude, required this.longitude});

  factory PositionResponse.fromJson(Map<String, dynamic> json) {
    return PositionResponse(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  PositionResponse.fromPosition(Position position)
    : latitude = position.latitude,
      longitude = position.longitude;

  // to json
  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }

  @override
  String toString() {
    return "$latitude,$longitude";
  }
}
