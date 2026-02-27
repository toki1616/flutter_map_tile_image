import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';

import '../application/providers/map_providers.dart';

// 分割したウィジェット
import 'widgets/map_fab_buttons.dart';
import 'widgets/crosshair_painter.dart';
import 'widgets/mode_select_window.dart';
import 'widgets/line/editor_window_switcher.dart';
import 'widgets/coordinate_display.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapControllerProvider);
    final mapCtrl = ref.read(mapControllerProvider.notifier);

    final mapController = MapController();

    final tileDir = ref.watch(tileDirectoryProvider);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("ローカルタイルマップ"),
      // ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: mapState.center,
              zoom: mapState.zoom,
              maxZoom: 18,
              minZoom: 3,
              onTap: (tapPos, latlng) {
                if (mapState.isLineMode) {
                  mapCtrl.addPoint(latlng);
                }
              },
              onPositionChanged: (pos, _) {
                mapCtrl.updateCenter(pos.center!);
                mapCtrl.updateZoom(pos.zoom!);
              },
            ),
            children: [
              TileLayer(
                tileProvider: tileDir == null
                ? AssetTileProvider()
                      : FileTileProvider(),
              urlTemplate: tileDir == null
              ? ""
                  : "$tileDir/{z}/{x}/{y}.png",
              ),
              PolylineLayer(
                polylines: [
                  // ① 保存済みの MapLine をすべて描画
                  for (final line in mapState.savedLines)
                    Polyline(
                      points: line.attributes.expand((attr) => attr.points).toList(),
                      strokeWidth: line.lineWidth,
                      color: line.lineColor,
                    ),

                  // ② ラインファイル編集中（editingLine）の属性を描画
                  if (mapState.editingLine != null)
                    for (final attr in mapState.editingLine!.attributes)
                      Polyline(
                        points: attr.points,
                        strokeWidth: mapState.editingLine!.lineWidth,
                        color: mapState.editingLine!.lineColor.withOpacity(0.7),
                      ),

                  // ③ 属性編集中（editingAttribute）の points を描画
                  if (mapState.editingAttribute != null)
                    Polyline(
                      points: mapState.editingAttribute!.points,
                      strokeWidth: mapState.editingLine?.lineWidth ?? 4,
                      color: (mapState.editingLine?.lineColor ?? Colors.blue)
                          .withOpacity(0.9),
                    ),

                  // ④ currentPoints（モード中にマップタップで追加している点）
                  if (mapState.currentPoints.isNotEmpty)
                    Polyline(
                      points: mapState.currentPoints,
                      strokeWidth: 4,
                      color: Colors.blue,
                    ),
                ],
              ),
            ],
          ),

          Center(
            child: IgnorePointer(
              child: CustomPaint(
                size: const Size(40, 40),
                painter: CrosshairPainter(),
              ),
            ),
          ),

          const ModeSelectWindow(),
          const EditorWindowSwitcher(),
          const CoordinateDisplay(),

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
