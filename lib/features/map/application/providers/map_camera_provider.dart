import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapCameraState {
  final double centerLat;
  final double centerLng;
  final double zoom;

  const MapCameraState({
    required this.centerLat,
    required this.centerLng,
    required this.zoom,
  });

  factory MapCameraState.initial() => const MapCameraState(
    centerLat: 35.681236, // 初期座標
    centerLng: 139.767125,
    zoom: 4.0,            // 初期ズーム
  );

  MapCameraState copyWith({
    double? centerLat,
    double? centerLng,
    double? zoom,
  }) {
    return MapCameraState(
      centerLat: centerLat ?? this.centerLat,
      centerLng: centerLng ?? this.centerLng,
      zoom: zoom ?? this.zoom,
    );
  }
}

class MapCameraNotifier extends AutoDisposeNotifier<MapCameraState> {
  @override
  MapCameraState build() {
    return MapCameraState.initial();
  }

  void updateCamera(double lat, double lng, double zoom) {
    state = state.copyWith(centerLat: lat, centerLng: lng, zoom: zoom);
  }
}

final mapCameraProvider = AutoDisposeNotifierProvider<MapCameraNotifier, MapCameraState>(() {
  return MapCameraNotifier();
});