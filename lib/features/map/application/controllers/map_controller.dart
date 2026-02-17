import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/map_line.dart';
import '../../domain/usecases/save_line.dart';
import '../../domain/usecases/load_line.dart';
import 'map_state.dart';

class MapController extends StateNotifier<MapState> {
  final SaveLine saveLine;
  final LoadLine loadLine;

  MapController({
    required this.saveLine,
    required this.loadLine,
  }) : super(MapState.initial()) {
    _loadSavedLine();
  }

  Future<void> _loadSavedLine() async {
    final loaded = await loadLine();
    if (loaded != null) {
      state = state.copyWith(linePoints: loaded.points);
    }
  }

  void updateCenter(LatLng center) {
    state = state.copyWith(center: center);
  }

  void updateZoom(double zoom) {
    state = state.copyWith(zoom: zoom);
  }

  void toggleLineMode() {
    state = state.copyWith(
      isLineMode: !state.isLineMode,
      linePoints: [],
    );
  }

  void addLinePoint(LatLng point) {
    if (!state.isLineMode) return;

    final updated = [...state.linePoints, point];
    state = state.copyWith(linePoints: updated);
  }

  Future<void> saveCurrentLine() async {
    await saveLine(MapLine(points: state.linePoints));
  }
}
