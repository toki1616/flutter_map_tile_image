import '../../domain/entities/map_point.dart';
import '../../domain/repositories/map_point_repository.dart';

class SavePointsUseCase {
  final MapPointRepository _repository;
  const SavePointsUseCase(this._repository);

  Future<void> call(List<MapPoint> points) async {
    await _repository.savePoints(points);
  }
}