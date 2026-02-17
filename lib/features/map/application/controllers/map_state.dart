import 'package:latlong2/latlong.dart';

class MapState {
  final LatLng center;
  final double zoom;
  final List<LatLng> linePoints;
  final bool isLineMode;

  const MapState({
    required this.center,
    required this.zoom,
    required this.linePoints,
    required this.isLineMode,
  });

  MapState copyWith({
    LatLng? center,
    double? zoom,
    List<LatLng>? linePoints,
    bool? isLineMode,
  }) {
    return MapState(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      linePoints: linePoints ?? this.linePoints,
      isLineMode: isLineMode ?? this.isLineMode,
    );
  }

  factory MapState.initial() => MapState(
    center: const LatLng(35.681236, 139.767125),
    zoom: 6,
    linePoints: [],
    isLineMode: false,
  );
}
