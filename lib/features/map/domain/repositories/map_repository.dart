import '../entities/map_line.dart';

abstract class MapRepository {
  Future<void> saveLines(List<MapLine> lines);
  Future<List<MapLine>> loadLines();
}
