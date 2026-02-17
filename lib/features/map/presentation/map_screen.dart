import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';

import '../application/providers/map_providers.dart';

// 分割したウィジェット
import 'widgets/map_fab_buttons.dart';
import 'widgets/crosshair_painter.dart';
import 'widgets/mode_select_window.dart';
import 'widgets/coordinate_display.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapControllerProvider);
    final mapCtrl = ref.read(mapControllerProvider.notifier);

    final mapController = MapController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("ローカルタイルマップ"),
      ),
      body: Stack(
        children: [
          // --- 地図本体 ---
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: mapState.center,
              zoom: mapState.zoom,
              maxZoom: 18,
              minZoom: 3,
              onTap: (tapPos, latlng) {
                if (mapState.isLineMode) {
                  mapCtrl.addLinePoint(latlng);
                }
              },
              onPositionChanged: (pos, _) {
                mapCtrl.updateCenter(pos.center!);
                mapCtrl.updateZoom(pos.zoom!);
              },
            ),
            children: [
              TileLayer(
                tileProvider: AssetTileProvider(),
                urlTemplate: "assets/images/tiles/{z}/{x}/{y}.png",
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: mapState.linePoints,
                    strokeWidth: 4,
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),

          // --- 画面中央の十字線 ---
          Center(
            child: IgnorePointer(
              child: CustomPaint(
                size: Size(40, 40),
                painter: CrosshairPainter(),
              ),
            ),
          ),

          // --- 上部モード選択ウィンドウ ---
          const ModeSelectWindow(),

          // --- 座標表示 ---
          const CoordinateDisplay(),

          // --- 右下の FAB ボタン群 ---
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 16),
                child: MapFabButtons(mapController: mapController),
              ),
            ),
          ),
        ],
      ),
    );
  }
}