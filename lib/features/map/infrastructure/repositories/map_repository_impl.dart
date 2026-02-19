import '../../domain/entities/map_line.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/map_local_datasource.dart';

class MapRepositoryImpl implements MapRepository {
  final MapLocalDataSource dataSource;

  MapRepositoryImpl(this.dataSource);

  @override
  Future<void> saveLines(List<MapLine> lines) {
    return dataSource.saveLines(lines);
  }

  @override
  Future<List<MapLine>> loadLines() {
    return dataSource.loadLines();
  }
}
