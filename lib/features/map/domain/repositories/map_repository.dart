import '../entities/map_line.dart';
import '../entities/map_pin.dart';

abstract class MapRepository {
  Future<void> saveLine(MapLine line);
  Future<MapLine?> loadLine();

  // Future<void> savePin(MapPin pin);
  // Future<MapPin?> loadPin();
}
