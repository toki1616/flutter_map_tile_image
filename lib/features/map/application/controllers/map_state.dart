import 'package:latlong2/latlong.dart';

class MapState {
  final LatLng center;
  final double zoom;

  // ライン描画用ポイント
  final List<LatLng> linePoints;

  // ラインモード
  final bool isLineMode;

  // ★ ポリゴンモード（追加）
  final bool isPolygonMode;

  const MapState({
    required this.center,
    required this.zoom,
    required this.linePoints,
    required this.isLineMode,
    required this.isPolygonMode,
  });

  MapState copyWith({
    LatLng? center,
    double? zoom,
    List<LatLng>? linePoints,
    bool? isLineMode,
    bool? isPolygonMode,
  }) {
    return MapState(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      linePoints: linePoints ?? this.linePoints,
      isLineMode: isLineMode ?? this.isLineMode,
      isPolygonMode: isPolygonMode ?? this.isPolygonMode,
    );
  }

  factory MapState.initial() => MapState(
    center: const LatLng(35.681236, 139.767125),
    zoom: 6,
    linePoints: [],
    isLineMode: false,
    isPolygonMode: false, // ★ 初期値は false
  );
}
