import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// マップの情報表示
class CoordinateDisplay extends StatelessWidget {
  final LatLng centerCoordinate;

  const CoordinateDisplay({
    super.key,
    required this.centerCoordinate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: 10,
      child: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "Lat: ${centerCoordinate.latitude.toStringAsFixed(6)}\nLng: ${centerCoordinate.longitude.toStringAsFixed(6)}",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}