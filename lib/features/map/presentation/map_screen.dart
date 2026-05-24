import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../application/providers/map_camera_provider.dart';

import 'widgets/center_crosshair.dart';
import 'widgets/coordinate_display.dart';
import 'widgets/map_fab_buttons.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(mapCameraProvider);

    // アプリケーション層の状態が外部から変わったらマップカメラを同期する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentCenter = _mapController.camera.center;
      final currentZoom = _flutterMapZoomNormalized(_mapController.camera.zoom);

      // cameraState を参照
      if (currentCenter.latitude != cameraState.centerLat ||
          currentCenter.longitude != cameraState.centerLng ||
          currentZoom != cameraState.zoom) {
        _mapController.move(LatLng(cameraState.centerLat, cameraState.centerLng), cameraState.zoom);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("ローカルタイルマップ"),
      ),
      body: Stack(
        children: [
          // 地図ベース
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(cameraState.centerLat, cameraState.centerLng),
              initialZoom: cameraState.zoom,
              maxZoom: 18,
              minZoom: 3,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  final center = position.center;
                  final zoom = position.zoom;

                  if (center != null && zoom != null) {
                    ref.read(mapCameraProvider.notifier).updateCamera(
                      center.latitude,
                      center.longitude,
                      zoom,
                    );
                  }
                }
              },
            ),
            children: [
              TileLayer(
                tileProvider: AssetTileProvider(),
                urlTemplate: "assets/images/tiles/{z}/{x}/{y}.png",
              ),
            ],
          ),

          // 画面中央十字線
          const CenterCrosshair(),

          // 座標情報ディスプレイ
          CoordinateDisplay(
            centerCoordinate: LatLng(cameraState.centerLat, cameraState.centerLng),
          ),

          // 右下配置のFAB操作層
          Positioned(
            right: 0,
            bottom: 0,
            child: MapFabButtons(
              onZoomIn: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1),
              onZoomOut: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1),
            ),
          ),
        ],
      ),
    );
  }

  double _flutterMapZoomNormalized(double zoom) {
    return double.parse(zoom.toStringAsFixed(2));
  }
}