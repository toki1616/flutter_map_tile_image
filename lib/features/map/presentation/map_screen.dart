import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  double _zoom = 6;

  LatLng _center = const LatLng(35.681236, 139.767125);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ローカルタイルマップ"),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _center,
              zoom: _zoom,
              maxZoom: 18,
              minZoom: 3,
              onPositionChanged: (pos, _) {
                setState(() {
                  _zoom = pos.zoom!;
                  _center = pos.center!;
                });
              },
            ),
            children: [
              TileLayer(
                tileProvider: AssetTileProvider(),
                urlTemplate: "assets/images/tiles/{z}/{x}/{y}.png",
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
                "Lat: ${_center.latitude.toStringAsFixed(6)}\nLng: ${_center.longitude.toStringAsFixed(6)}",
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
                    //Zoom In
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _btn(Icons.add, () {
                          _mapController.move(
                            _mapController.camera.center,
                            _zoom + 1,
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //Zoom Out
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _btn(Icons.remove, () {
                          _mapController.move(
                            _mapController.camera.center,
                            _zoom - 1,
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 共通の小ボタン
  Widget _btn(IconData icon, VoidCallback onPressed) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      mini: false,
      onPressed: onPressed,
      child: Icon(icon),
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

    // 横線
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      paint,
    );

    // 縦線
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
