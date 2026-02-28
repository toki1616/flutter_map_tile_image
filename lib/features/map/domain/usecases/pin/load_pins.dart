import '../../../domain/entities/map_pin.dart';
import '../../../domain/repositories/map_pin_repository.dart';

class LoadPins {
  final MapPinRepository repository;

  LoadPins(this.repository);

  Future<List<MapPin>> call() async {
    return await repository.loadPins();
  }
}
