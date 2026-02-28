import '../../../domain/entities/map_pin.dart';
import '../../../domain/repositories/map_pin_repository.dart';

class UpdatePin {
  final MapPinRepository repository;

  UpdatePin(this.repository);

  Future<void> call(
      MapPin oldPin, MapPin newPin, List<MapPin> currentPins) async {
    final updated = currentPins.map((p) {
      return p == oldPin ? newPin : p;
    }).toList();

    await repository.savePins(updated);
  }
}
