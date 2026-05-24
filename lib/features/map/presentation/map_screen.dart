import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'widgets/center_crosshair.dart';
import 'widgets/coordinate_display.dart';
import 'widgets/map_fab_buttons.dart';

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

          // 十字線コンポーネント
          const CenterCrosshair(),

          // 位置情報表示コンポーネント (現在の中心座標を渡す)
          CoordinateDisplay(centerCoordinate: _center),

          // ズームボタンコンポーネント (ボタンが押された時の処理を渡す)
          MapFabButtons(
            onZoomIn: () {
              _mapController.move(_mapController.camera.center, _zoom + 1);
            },
            onZoomOut: () {
              _mapController.move(_mapController.camera.center, _zoom - 1);
            },
          ),
        ],
      ),
    );
  }
}