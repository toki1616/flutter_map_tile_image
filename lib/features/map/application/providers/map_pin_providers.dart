import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/datasources/map_pin_local_datasource.dart';
import '../../infrastructure/repositories/map_pin_repository_impl.dart';
import '../../domain/repositories/map_pin_repository.dart';
import '../controllers/map_pin_controller.dart';
import '../state/map_pin_state.dart';

final mapPinRepositoryProvider = Provider<MapPinRepository>((ref) {
  return MapPinRepositoryImpl(MapPinLocalDatasource());
});

final mapPinControllerProvider =
StateNotifierProvider<MapPinController, MapPinState>((ref) {
  return MapPinController(ref.read(mapPinRepositoryProvider));
});
