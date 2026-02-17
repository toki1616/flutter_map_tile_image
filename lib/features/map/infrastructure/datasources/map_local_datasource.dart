import 'package:latlong2/latlong.dart';
import 'package:map_tile_image/features/save/json_save/infrastructure/datasources/json_save_utils.dart';

class MapLocalDataSource {
  Future<void> saveLine(List<LatLng> points) async {
    final json = {
      "points": points
          .map((p) => {"lat": p.latitude, "lng": p.longitude})
          .toList(),
    };

    await SaveUtils.save("map_line", json);
  }

  Future<List<LatLng>?> loadLine() async {
    final json = await SaveUtils.load("map_line");
    if (json == null) return null;

    final list = json["points"] as List<dynamic>;
    return list
        .map((m) => LatLng(m["lat"], m["lng"]))
        .toList();
  }
}