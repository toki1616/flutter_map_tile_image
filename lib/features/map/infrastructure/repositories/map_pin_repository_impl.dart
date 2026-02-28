import '../../domain/entities/map_pin.dart';
import '../../domain/repositories/map_pin_repository.dart';
import '../datasources/map_pin_local_datasource.dart';

class MapPinRepositoryImpl implements MapPinRepository {
  final MapPinLocalDatasource datasource;

  MapPinRepositoryImpl(this.datasource);

  @override
  Future<List<MapPin>> loadPins() => datasource.loadPins();

  @override
  Future<void> savePins(List<MapPin> pins) => datasource.savePins(pins);
}
