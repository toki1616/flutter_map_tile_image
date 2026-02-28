import 'package:latlong2/latlong.dart';

class MapPin {
  final String data;
  final DateTime createdAt;
  final LatLng point;

  const MapPin({
    required this.data,
    required this.createdAt,
    required this.point,
  });

  MapPin copyWith({
    String? data,
    DateTime? createdAt,
    LatLng? point,
  }) {
    return MapPin(
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      point: point ?? this.point,
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data,
    "createdAt": createdAt.toIso8601String(),
    "lat": point.latitude,
    "lng": point.longitude,
  };

  factory MapPin.fromJson(Map<String, dynamic> json) {
    return MapPin(
      data: json["data"],
      createdAt: DateTime.parse(json["createdAt"]),
      point: LatLng(json["lat"], json["lng"]),
    );
  }
}
