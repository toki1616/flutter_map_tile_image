import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/line/create_line.dart';
import '../../domain/usecases/line/delete_line.dart';
import '../../domain/usecases/line/rename_line.dart';
import '../../domain/usecases/line/load_line.dart';

import '../../domain/usecases/line_attribute/create_attribute.dart';
import '../../domain/usecases/line_attribute/delete_attribute.dart';
import '../../domain/usecases/line_attribute/rename_attribute.dart';
import '../../domain/usecases/line_attribute/update_attribute_points.dart';

import '../../infrastructure/datasources/map_local_datasource.dart';
import '../../infrastructure/repositories/map_repository_impl.dart';

import '../../domain/repositories/map_repository.dart';

import '../controllers/map_controller.dart';
import '../state/map_state.dart';

// DataSource
final mapLocalDataSourceProvider =
Provider((ref) => MapLocalDataSource());

// Repository
final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepositoryImpl(ref.read(mapLocalDataSourceProvider));
});

// UseCases: Line
final createLineProvider = Provider((ref) => const CreateLine());
final deleteLineProvider = Provider((ref) => const DeleteLine());
final renameLineProvider = Provider((ref) => const RenameLine());
final loadLineProvider = Provider((ref) => const LoadLine());

// UseCases: LineAttribute
final createAttributeProvider =
Provider((ref) => const CreateAttribute());
final deleteAttributeProvider =
Provider((ref) => const DeleteAttribute());
final renameAttributeProvider =
Provider((ref) => const RenameAttribute());
final updateAttributePointsProvider =
Provider((ref) => const UpdateAttributePoints());

// Controller
final mapControllerProvider =
StateNotifierProvider<MapController, MapState>((ref) {
  return MapController(
    createLine: ref.read(createLineProvider),
    deleteLine: ref.read(deleteLineProvider),
    renameLine: ref.read(renameLineProvider),
    loadLine: ref.read(loadLineProvider),
    createAttribute: ref.read(createAttributeProvider),
    deleteAttribute: ref.read(deleteAttributeProvider),
    renameAttribute: ref.read(renameAttributeProvider),
    updateAttributePoints: ref.read(updateAttributePointsProvider),
    repository: ref.read(mapRepositoryProvider),
  );
});

final tileDirectoryProvider = StateProvider<String?>((ref) => null);
