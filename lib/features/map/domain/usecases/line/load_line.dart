import 'package:latlong2/latlong.dart';
import '../../entities/map_line.dart';

class LoadLine {
  const LoadLine();

  List<LatLng> call(List<MapLine> lines, int index) {
    if (index < 0 || index >= lines.length) return const [];

    final line = lines[index];
    if (line.attributes.isEmpty) return const [];

    return line.attributes.first.points;
  }
}
