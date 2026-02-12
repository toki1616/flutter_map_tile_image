import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ローカルタイルマップ"),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(35.681236, 139.767125), // 東京駅あたり
          zoom: 6,
          maxZoom: 18,
          minZoom: 3,
        ),
        children: [
          TileLayer(
            tileProvider: AssetTileProvider(),
            urlTemplate: "assets/images/tiles/{z}/{x}/{y}.png",
          ),
        ],
      ),
    );
  }
}
