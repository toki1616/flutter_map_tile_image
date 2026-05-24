import 'package:meta/meta.dart';

@immutable
class MapPoint {
  final String id;
  final String title;
  final String memo;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final bool isVisible;

  const MapPoint({
    required this.id,
    required this.title,
    required this.memo,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.isVisible = true,
  });

  MapPoint copyWith({
    String? id,
    String? title,
    String? memo,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    bool? isVisible,
  }) {
    return MapPoint(
      id: id ?? this.id,
      title: title ?? this.title,
      memo: memo ?? this.memo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'memo': memo,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'isVisible': isVisible,
    };
  }

  factory MapPoint.fromJson(Map<String, dynamic> json) {
    return MapPoint(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      memo: json['memo'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isVisible: json['isVisible'] as bool? ?? true,
    );
  }
}