import 'package:latlong2/latlong.dart';
import '../../entities/map_line.dart';

class UpdateAttributePoints {
  const UpdateAttributePoints();

  MapLine call(
      MapLine line, {
        required int index,
        required List<LatLng> newPoints,
      }) {
    if (index < 0 || index >= line.attributes.length) return line;

    final attrs = [...line.attributes];
    attrs[index] = attrs[index].copyWith(points: newPoints);

    return line.copyWith(attributes: attrs);
  }
}
