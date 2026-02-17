import '../entities/map_line.dart';
import '../repositories/map_repository.dart';

class LoadLine {
  final MapRepository repository;

  LoadLine(this.repository);

  Future<MapLine?> call() {
    return repository.loadLine();
  }
}
