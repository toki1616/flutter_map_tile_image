import '../entities/map_pin.dart';

abstract class MapPinRepository {
  Future<List<MapPin>> loadPins();
  Future<void> savePins(List<MapPin> pins);
}
