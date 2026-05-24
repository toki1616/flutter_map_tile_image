import '../../domain/entities/map_point.dart';
import '../../domain/repositories/map_point_repository.dart';

class LoadPointsUseCase {
  final MapPointRepository _repository;
  const LoadPointsUseCase(this._repository);

  Future<List<MapPoint>> call() async {
    return await _repository.loadPoints();
  }
}