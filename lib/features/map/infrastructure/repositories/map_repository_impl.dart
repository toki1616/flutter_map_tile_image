import '../../domain/entities/map_line.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/map_local_datasource.dart';

class MapRepositoryImpl implements MapRepository {
  final MapLocalDataSource dataSource;

  MapRepositoryImpl(this.dataSource);

  @override
  Future<void> saveLine(MapLine line) {
    return dataSource.saveLine(line.points);
  }

  @override
  Future<MapLine?> loadLine() async {
    final points = await dataSource.loadLine();
    if (points == null) return null;
    return MapLine(points: points);
  }
}