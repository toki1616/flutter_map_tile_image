import 'package:latlong2/latlong.dart';

import '../../../../features/save/json_save/infrastructure/datasources/json_save_utils.dart';

import '../../domain/entities/map_line.dart';

class MapLocalDataSource {
  Future<void> saveLines(List<MapLine> lines) async {
    final json = {
      "lines": lines.map((line) {
        return {
          "title": line.title,
          "attributes": line.attributes.map((attr) {
            return {
              "title": attr.title,
              "points": attr.points
                  .map((p) => {"lat": p.latitude, "lng": p.longitude})
                  .toList(),
            };
          }).toList(),
        };
      }).toList(),
    };

    await SaveUtils.save("map_lines", json);
  }

  Future<List<MapLine>> loadLines() async {
    final json = await SaveUtils.load("map_lines");
    if (json == null) return [];

    final list = json["lines"] as List<dynamic>;

    return list.map((lineJson) {
      final attrs =
      (lineJson["attributes"] as List<dynamic>).map((attrJson) {
        final points = (attrJson["points"] as List<dynamic>)
            .map((p) => LatLng(p["lat"], p["lng"]))
            .toList();

        return MapLineAttribute(
          title: attrJson["title"],
          points: points,
        );
      }).toList();

      return MapLine(
        title: lineJson["title"],
        attributes: attrs,
      );
    }).toList();
  }
}
