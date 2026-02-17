import '../entities/map_line.dart';

abstract class MapRepository {
  Future<void> saveLine(MapLine line);
  Future<MapLine?> loadLine();
}
