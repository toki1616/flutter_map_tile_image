import '../entities/map_line.dart';
import '../repositories/map_repository.dart';

class SaveLine {
  final MapRepository repository;

  SaveLine(this.repository);

  Future<void> call(MapLine line) {
    return repository.saveLine(line);
  }
}