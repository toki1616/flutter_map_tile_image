import '../../../domain/entities/map_pin.dart';
import '../../../domain/repositories/map_pin_repository.dart';

class AddPin {
  final MapPinRepository repository;

  AddPin(this.repository);

  Future<void> call(MapPin pin, List<MapPin> currentPins) async {
    final updated = [...currentPins, pin];
    await repository.savePins(updated);
  }
}
