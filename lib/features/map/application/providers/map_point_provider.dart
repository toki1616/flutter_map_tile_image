import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/map_point.dart';
import '../../infrastructure/datasources/map_point_local_datasource.dart';
import '../../infrastructure/repositories/map_point_repository_impl.dart';
import '../usecases/load_points_usecase.dart';
import '../usecases/save_points_usecase.dart';
import 'map_camera_provider.dart';
import 'mode_window_provider.dart';

class MapPointState {
  final List<MapPoint> savedPoints;
  final int? selectedPointIndex;
  final MapPoint? editingPoint;
  final int? editingPointIndex;

  const MapPointState({
    required this.savedPoints,
    this.selectedPointIndex,
    this.editingPoint,
    this.editingPointIndex,
  });

  factory MapPointState.initial() => const MapPointState(
    savedPoints: [],
  );

  MapPointState copyWith({
    List<MapPoint>? savedPoints,
    int? selectedPointIndex,
    MapPoint? editingPoint,
    int? editingPointIndex,
    bool clearSelectedPointIndex = false,
    bool clearEditingPoint = false,
  }) {
    return MapPointState(
      savedPoints: savedPoints ?? this.savedPoints,
      selectedPointIndex: clearSelectedPointIndex ? null : (selectedPointIndex ?? this.selectedPointIndex),
      editingPoint: clearEditingPoint ? null : (editingPoint ?? this.editingPoint),
      editingPointIndex: clearEditingPoint ? null : (editingPointIndex ?? this.editingPointIndex),
    );
  }
}

class MapPointNotifier extends AutoDisposeNotifier<MapPointState> {
  late final SavePointsUseCase _savePointsUseCase;
  late final LoadPointsUseCase _loadPointsUseCase;

  @override
  MapPointState build() {
    final dataSource = MapPointLocalDataSource();
    final repository = MapPointRepositoryImpl(dataSource);
    _savePointsUseCase = SavePointsUseCase(repository);
    _loadPointsUseCase = LoadPointsUseCase(repository);

    _initLoad();
    return MapPointState.initial();
  }

  Future<void> _initLoad() async {
    final points = await _loadPointsUseCase();
    state = state.copyWith(savedPoints: points);
  }

  // リストの項目を選択
  void selectPoint(int index) {
    state = state.copyWith(selectedPointIndex: index);
  }

  // 表示/非表示の切り替え
  void toggleVisibility(int index) {
    final updated = [...state.savedPoints];
    updated[index] = updated[index].copyWith(isVisible: !updated[index].isVisible);
    state = state.copyWith(savedPoints: updated);
    _savePointsUseCase(updated); // 状態を保存
  }

  // ポイントを削除
  void deletePoint(int index) {
    final updated = [...state.savedPoints]..removeAt(index);
    state = state.copyWith(
      savedPoints: updated,
      clearSelectedPointIndex: true,
    );
    _savePointsUseCase(updated);
  }

  // 新規作成を開始
  void startNewPoint() {
    final cameraState = ref.read(mapCameraProvider);
    final newPoint = MapPoint(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      memo: '',
      latitude: cameraState.centerLat,
      longitude: cameraState.centerLng,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(editingPoint: newPoint, clearEditingPoint: false);
    ref.read(modeWindowProvider.notifier).state = MapEditorMode.pointEditor;
  }

  // 既存ポイントの編集を開始
  void startEditPoint(int index) {
    state = state.copyWith(
      editingPoint: state.savedPoints[index],
      editingPointIndex: index,
    );
    ref.read(modeWindowProvider.notifier).state = MapEditorMode.pointEditor;
  }

  void updateTitle(String text) {
    if (state.editingPoint == null) return;
    state = state.copyWith(editingPoint: state.editingPoint!.copyWith(title: text));
  }

  void updateMemo(String text) {
    if (state.editingPoint == null) return;
    state = state.copyWith(editingPoint: state.editingPoint!.copyWith(memo: text));
  }

  void updateEditingPointPosition() {
    if (state.editingPoint == null) return;

    // 現在のカメラ中央座標を取得
    final cameraState = ref.read(mapCameraProvider);

    // 編集中のピンの座標を上書き
    state = state.copyWith(
      editingPoint: state.editingPoint!.copyWith(
        latitude: cameraState.centerLat,
        longitude: cameraState.centerLng,
      ),
    );
  }

  Future<void> saveEditingPoint() async {
    if (state.editingPoint == null) return;

    final updatedList = [...state.savedPoints];
    if (state.editingPointIndex == null) {
      updatedList.add(state.editingPoint!); // 新規追加
    } else {
      updatedList[state.editingPointIndex!] = state.editingPoint!; // 既存更新
    }

    state = state.copyWith(
      savedPoints: updatedList,
      clearEditingPoint: true,
    );

    // 保存後は一覧画面に戻る
    ref.read(modeWindowProvider.notifier).state = MapEditorMode.pointFileList;
    await _savePointsUseCase(updatedList);
  }

  void cancelEditing() {
    state = state.copyWith(clearEditingPoint: true);
    // キャンセル時は一覧画面に戻る
    ref.read(modeWindowProvider.notifier).state = MapEditorMode.pointFileList;
  }
}

final mapPointProvider = AutoDisposeNotifierProvider<MapPointNotifier, MapPointState>(() {
  return MapPointNotifier();
});