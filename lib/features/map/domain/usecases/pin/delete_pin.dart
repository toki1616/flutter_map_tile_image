import '../../../domain/entities/map_pin.dart';
import '../../../domain/repositories/map_pin_repository.dart';

class DeletePin {
  final MapPinRepository repository;

  DeletePin(this.repository);

  Future<void> call(MapPin pin, List<MapPin> currentPins) async {
    final updated = currentPins.where((p) => p != pin).toList();
    await repository.savePins(updated);
  }
}
