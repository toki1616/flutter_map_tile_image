import '../entities/map_point.dart';

abstract class MapPointRepository {
  Future<void> savePoints(List<MapPoint> points);
  Future<List<MapPoint>> loadPoints();
}