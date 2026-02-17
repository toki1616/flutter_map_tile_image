import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/save_line.dart';
import '../../domain/usecases/load_line.dart';
import '../../infrastructure/datasources/map_local_datasource.dart';
import '../../infrastructure/repositories/map_repository_impl.dart';
import '../controllers/map_controller.dart';
import '../controllers/map_state.dart';

// DataSource
final mapLocalDataSourceProvider = Provider((ref) => MapLocalDataSource());

// Repository
final mapRepositoryProvider = Provider((ref) {
  return MapRepositoryImpl(ref.read(mapLocalDataSourceProvider));
});

// UseCases
final saveLineProvider = Provider((ref) {
  return SaveLine(ref.read(mapRepositoryProvider));
});

final loadLineProvider = Provider((ref) {
  return LoadLine(ref.read(mapRepositoryProvider));
});

final modeWindowVisibleProvider = StateProvider<bool>((ref) => false);

// Controller
final mapControllerProvider =
StateNotifierProvider<MapController, MapState>((ref) {
  return MapController(
    saveLine: ref.read(saveLineProvider),
    loadLine: ref.read(loadLineProvider),
  );
});
