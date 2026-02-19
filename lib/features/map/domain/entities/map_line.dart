import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapLine {
  final String title;
  final Color lineColor;
  final double lineWidth;
  final List<MapLineAttribute> attributes;

  const MapLine({
    required this.title,
    required this.attributes,
    this.lineColor = Colors.blue,
    this.lineWidth = 4.0,
  });

  factory MapLine.fromJson(Map<String, dynamic> json) {
    return MapLine(
      title: json["title"],
      lineColor: Color(json["lineColor"]),
      lineWidth: (json["lineWidth"] as num).toDouble(),
      attributes: (json["attributes"] as List)
          .map((a) => MapLineAttribute.fromJson(a))
          .toList(),
    );
  }

  /// JSON へ変換
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "lineColor": lineColor.value,
      "lineWidth": lineWidth,
      "attributes": attributes.map((a) => a.toJson()).toList(),
    };
  }

  MapLine copyWith({
    String? title,
    Color? lineColor,
    double? lineWidth,
    List<MapLineAttribute>? attributes,
  }) {
    return MapLine(
      title: title ?? this.title,
      lineColor: lineColor ?? this.lineColor,
      lineWidth: lineWidth ?? this.lineWidth,
      attributes: attributes ?? this.attributes,
    );
  }
}

class MapLineAttribute {
  final String title;
  final List<LatLng> points;

  const MapLineAttribute({
    required this.title,
    required this.points,
  });

  factory MapLineAttribute.fromJson(Map<String, dynamic> json) {
    return MapLineAttribute(
      title: json["title"],
      points: (json["points"] as List)
          .map((p) => LatLng(p["lat"], p["lng"]))
          .toList(),
    );
  }

  /// JSON へ変換
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "points": points
          .map((p) => {"lat": p.latitude, "lng": p.longitude})
          .toList(),
    };
  }

  MapLineAttribute copyWith({
    String? title,
    List<LatLng>? points,
  }) {
    return MapLineAttribute(
      title: title ?? this.title,
      points: points ?? this.points,
    );
  }
}
