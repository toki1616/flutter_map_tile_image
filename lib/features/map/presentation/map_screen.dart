import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../application/providers/map_camera_provider.dart';
import '../application/providers/map_point_provider.dart';
import '../application/providers/mode_window_provider.dart';

import 'widgets/center_crosshair.dart';
import 'widgets/coordinate_display.dart';
import 'widgets/map_fab_buttons.dart';
import 'widgets/point/map_point_editor_window.dart';
import 'widgets/point/map_point_list_window.dart';

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
    final pointState = ref.watch(mapPointProvider);
    final editorMode = ref.watch(modeWindowProvider);

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

              /// ------------------------------------------------------------
              /// 登録されたポイント(ピン)の描画
              /// ------------------------------------------------------------
              MarkerLayer(
                markers: [
                  // 既存の保存済みポイント（インデックスが必要なため asMap().entries を使用）
                  ...pointState.savedPoints.asMap().entries
                      .where((entry) => entry.value.isVisible) // 非表示のものは除外
                      .map((entry) {
                    final index = entry.key;
                    final point = entry.value;

                    final isEditingThis = pointState.editingPointIndex == index;
                    final displayPoint = isEditingThis ? pointState.editingPoint! : point;

                    return Marker(
                      point: LatLng(displayPoint.latitude, displayPoint.longitude),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          if (!isEditingThis) {
                            ref.read(mapPointProvider.notifier).startEditPoint(index);
                          }
                        },
                        child: Icon(
                          Icons.location_on,
                          color: isEditingThis ? Colors.blue : Colors.red,
                          size: 40,
                        ),
                      ),
                    );
                  }), // toList() はスプレッド演算子(...)が展開してくれるので不要です

                  // 新規作成中のポイント（リストにまだ無いもの）
                  if (pointState.editingPoint != null && pointState.editingPointIndex == null)
                    Marker(
                      point: LatLng(
                          pointState.editingPoint!.latitude,
                          pointState.editingPoint!.longitude
                      ),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
                    ),
                ],
              ),
            ],
          ),

          // 画面中央十字線
          const CenterCrosshair(),

          // 座標情報ディスプレイ
          CoordinateDisplay(
            centerCoordinate: LatLng(cameraState.centerLat, cameraState.centerLng),
          ),

          // 左上の入力ウィンドウ
          if (editorMode == MapEditorMode.pointFileList)
            const MapPointListWindow(),
          if (editorMode == MapEditorMode.pointEditor)
            const MapPointEditorWindow(),

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