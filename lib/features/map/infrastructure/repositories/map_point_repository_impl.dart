import '../../domain/entities/map_point.dart';
import '../../domain/repositories/map_point_repository.dart';
import '../datasources/map_point_local_datasource.dart';

class MapPointRepositoryImpl implements MapPointRepository {
  final MapPointLocalDataSource _dataSource;
  MapPointRepositoryImpl(this._dataSource);

  @override
  Future<void> savePoints(List<MapPoint> points) async {
    await _dataSource.save(points);
  }

  @override
  Future<List<MapPoint>> loadPoints() async {
    return await _dataSource.load();
  }
}