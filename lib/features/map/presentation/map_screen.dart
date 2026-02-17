import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';

import '../application/providers/map_providers.dart';

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
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: mapState.center,
              zoom: mapState.zoom,
              maxZoom: 18,
              minZoom: 3,

              // ★ ラインモードのときだけポイント追加
              onTap: (tapPos, latlng) {
                if (mapState.isLineMode) {
                  mapCtrl.addLinePoint(latlng);
                }
              },

              // ★ 中心・ズーム変更を Riverpod に反映
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

              // ★ ライン描画
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
                size: const Size(40, 40),
                painter: CrosshairPainter(),
              ),
            ),
          ),

          // --- 左上に中心座標を表示 ---
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Lat: ${mapState.center.latitude.toStringAsFixed(6)}\n"
                    "Lng: ${mapState.center.longitude.toStringAsFixed(6)}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),

          // --- SafeArea 内の右下にボタン配置 ---
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ★ ラインモード切替ボタン
                    FloatingActionButton(
                      heroTag: "lineMode",
                      backgroundColor:
                      mapState.isLineMode ? Colors.orange : Colors.grey,
                      child: const Icon(Icons.timeline),
                      onPressed: () {
                        mapCtrl.toggleLineMode();
                      },
                    ),
                    const SizedBox(height: 12),

                    // ★ 保存ボタン
                    FloatingActionButton(
                      heroTag: "saveLine",
                      child: const Icon(Icons.save),
                      onPressed: () async {
                        await mapCtrl.saveCurrentLine();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("ラインを保存しました")),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // 既存のズームイン
                    FloatingActionButton(
                      heroTag: "zoomIn",
                      child: const Icon(Icons.add),
                      onPressed: () {
                        mapController.move(
                          mapState.center,
                          mapState.zoom + 1,
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    // 既存のズームアウト
                    FloatingActionButton(
                      heroTag: "zoomOut",
                      child: const Icon(Icons.remove),
                      onPressed: () {
                        mapController.move(
                          mapState.center,
                          mapState.zoom - 1,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 十字線を描く Painter ---
class CrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
