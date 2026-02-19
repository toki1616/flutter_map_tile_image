import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'dart:developer';

import '../../../save/json_save/domain/entities/save_file_name.dart';
import '../../../save/json_save/infrastructure/datasources/json_save_utils.dart';
import '../../domain/entities/map_line.dart';
import '../../domain/repositories/map_repository.dart';

import '../../domain/usecases/line/create_line.dart';
import '../../domain/usecases/line/delete_line.dart';
import '../../domain/usecases/line/rename_line.dart';
import '../../domain/usecases/line/load_line.dart';

import '../../domain/usecases/line_attribute/create_attribute.dart';
import '../../domain/usecases/line_attribute/delete_attribute.dart';
import '../../domain/usecases/line_attribute/rename_attribute.dart';
import '../../domain/usecases/line_attribute/update_attribute_points.dart';

import '../state/map_state.dart';

class MapController extends StateNotifier<MapState> {
  MapController({
    required CreateLine createLine,
    required DeleteLine deleteLine,
    required RenameLine renameLine,
    required LoadLine loadLine,
    required CreateAttribute createAttribute,
    required DeleteAttribute deleteAttribute,
    required RenameAttribute renameAttribute,
    required UpdateAttributePoints updateAttributePoints,
    required MapRepository repository,
  })  : _createLine = createLine,
        _deleteLine = deleteLine,
        _renameLine = renameLine,
        _loadLine = loadLine,
        _createAttribute = createAttribute,
        _deleteAttribute = deleteAttribute,
        _renameAttribute = renameAttribute,
        _updateAttributePoints = updateAttributePoints,
        _repository = repository,
        super(MapState.initial()) {

    initialize();
  }

  final CreateLine _createLine;
  final DeleteLine _deleteLine;
  final RenameLine _renameLine;
  final LoadLine _loadLine;

  final CreateAttribute _createAttribute;
  final DeleteAttribute _deleteAttribute;
  final RenameAttribute _renameAttribute;
  final UpdateAttributePoints _updateAttributePoints;

  final MapRepository _repository;

  // ---------------------------------------------------------
  // ★ 起動時に呼ばれる初期化処理
  // ---------------------------------------------------------
  Future<void> initialize() async {
    await loadSavedLines(); // ★ JSON を読み込んで state.savedLines に復元
  }

  // ---------------------------------------------------------
  // JSON からラインを読み込む
  // ---------------------------------------------------------
  Future<void> loadSavedLines() async {
    log("📂 loadSavedLines() 開始");

    final data = await SaveUtils.load(SaveFileName.lines.fileName);

    if (data == null) {
      log("⚠️ 保存データなし（初回起動の可能性）");
      return;
    }

    log("📄 読み込んだ JSON: $data");

    try {
      final jsonList = data as List;

      log("📌 JSON List の長さ: ${jsonList.length}");

      final lines = jsonList
          .map((e) {
        log("➡️ MapLine.fromJson に渡すデータ: $e");
        return MapLine.fromJson(e as Map<String, dynamic>);
      })
          .toList();

      log("✅ 復元した MapLine の数: ${lines.length}");

      state = state.copyWith(savedLines: lines);

      log("🎉 state.savedLines に反映完了");

    } catch (e, stack) {
      log("❌ JSON パースエラー: $e");
      log("STACK: $stack");
    }
  }

  // ---------------------------------------------------------
  // モード切替
  // ---------------------------------------------------------
  void toggleLineMode() {
    state = state.copyWith(
      isLineMode: !state.isLineMode,
      isPolygonMode: false,
      selectedLineIndex: null,
      selectedAttributeIndex: null,
    );
  }

  void togglePolygonMode() {
    state = state.copyWith(
      isPolygonMode: !state.isPolygonMode,
      isLineMode: false,
      selectedLineIndex: null,
      selectedAttributeIndex: null,
    );
  }

  // ---------------------------------------------------------
  // 地図位置
  // ---------------------------------------------------------
  void updateCenter(LatLng center) {
    state = state.copyWith(center: center);
  }

  void updateZoom(double zoom) {
    state = state.copyWith(zoom: zoom);
  }

  // ---------------------------------------------------------
  // 点追加（編集中 or 既存ライン）
  // ---------------------------------------------------------
  ///マップタップ時の処理
  void addPoint(LatLng p) {
    // // 属性編集中の場合
    // if (state.editingAttribute != null) {
    //   final updated = state.editingAttribute!.copyWith(
    //     points: [...state.editingAttribute!.points, p],
    //   );
    //   state = state.copyWith(editingAttribute: updated);
    //   return;
    // }
    //
    // // 通常のライン描画
    // final lineIndex = state.selectedLineIndex;
    // final attrIndex = state.selectedAttributeIndex;
    //
    // if (lineIndex == null || attrIndex == null) {
    //   state = state.copyWith(
    //     currentPoints: [...state.currentPoints, p],
    //   );
    //   return;
    // }
    //
    // final lines = [...state.savedLines];
    // final line = lines[lineIndex];
    //
    // final updatedLine = _updateAttributePoints(
    //   line,
    //   index: attrIndex,
    //   newPoints: [...line.attributes[attrIndex].points, p],
    // );
    //
    // lines[lineIndex] = updatedLine;
    //
    // state = state.copyWith(savedLines: lines);
  }

  // ---------------------------------------------------------
  // ラインファイル一覧操作
  // ---------------------------------------------------------
  void createNewLine() {
    final updated = _createLine(state.savedLines);
    state = state.copyWith(savedLines: updated);
  }

  void deleteLine(int index) {
    final updated = _deleteLine(state.savedLines, index);
    state = state.copyWith(
      savedLines: updated,
      selectedLineIndex: null,
      selectedAttributeIndex: null,
    );
  }

  void selectLine(int index) {
    state = state.copyWith(
      selectedLineIndex: index,
      selectedAttributeIndex: null,
    );
  }

  // ---------------------------------------------------------
  // ラインファイル編集（LineFileEditorWindow 用）
  // ---------------------------------------------------------
  void startNewLineFile() {
    state = state.copyWith(
      editingLine: const MapLine(title: "", attributes: []),
      editingLineIndex: null,
    );
  }

  void startEditLineFile(int index) {
    state = state.copyWith(
      editingLine: state.savedLines[index],
      editingLineIndex: index,
    );
  }

  void updateEditingLineFileName(String name) {
    state = state.copyWith(
      editingLine: state.editingLine!.copyWith(title: name),
    );
  }

  void updateEditingLineColor(Color color) {
    state = state.copyWith(
      editingLine: state.editingLine!.copyWith(lineColor: color),
    );
  }

  void updateEditingLineWidth(double width) {
    state = state.copyWith(
      editingLine: state.editingLine!.copyWith(lineWidth: width),
    );
  }

  void saveEditingLineFile() async {
    final line = state.editingLine!;
    final index = state.editingLineIndex;

    final lines = [...state.savedLines];

    if (index == null) {
      lines.add(line);
    } else {
      lines[index] = line;
    }

    // ★ List<MapLine> をそのまま渡すだけで保存できる！
    await SaveUtils.save(
      SaveFileName.lines.fileName,
      lines,
    );

    state = state.copyWith(
      savedLines: lines,
      editingLine: null,
      editingLineIndex: null,
    );
  }

  /// ラインファイル作成のキャンセル（途中データ破棄）
  void cancelEditingLineFile() {
    state = state.copyWith(
      editingLine: null,
      editingLineIndex: null,
      editingAttribute: null,
      editingAttributeIndex: null,
    );
  }

  // ---------------------------------------------------------
  // 属性一覧操作
  // ---------------------------------------------------------
  void createNewAttribute() {
    final lineIndex = state.selectedLineIndex;
    if (lineIndex == null) return;

    final lines = [...state.savedLines];
    final line = lines[lineIndex];

    final updatedLine = _createAttribute(line);
    lines[lineIndex] = updatedLine;

    state = state.copyWith(savedLines: lines);
  }

  void deleteAttribute(int index) {
    final lineIndex = state.selectedLineIndex;
    if (lineIndex == null) return;

    final lines = [...state.savedLines];
    final line = lines[lineIndex];

    final updatedLine = _deleteAttribute(line, index);
    lines[lineIndex] = updatedLine;

    state = state.copyWith(
      savedLines: lines,
      selectedAttributeIndex: null,
    );
  }

  void selectAttribute(int index) {
    state = state.copyWith(selectedAttributeIndex: index);
  }

  /// ラインファイル編集画面で属性を削除する
  void deleteEditingAttribute() {
    final editingLine = state.editingLine;
    if (editingLine == null) return;

    final index = state.editingAttributeIndex;
    if (index == null) return;

    final attrs = [...editingLine.attributes];
    if (index < attrs.length) {
      attrs.removeAt(index);
    }

    state = state.copyWith(
      editingLine: editingLine.copyWith(attributes: attrs),
      editingAttribute: null,
      editingAttributeIndex: null,
    );
  }

  /// ライン作成画面のキャンセル（途中データ破棄）
  void cancelEditingAttribute() {
    state = state.copyWith(
      editingAttribute: null,
      editingAttributeIndex: null,
    );
  }

  // ---------------------------------------------------------
  // 属性編集（LineAttributeEditorWindow 用）
  // ---------------------------------------------------------
  void startNewAttribute() {
    state = state.copyWith(
      editingAttribute: const MapLineAttribute(title: "", points: []),
      editingAttributeIndex: null,
    );
  }

  void startEditingAttribute(int index) {
    final attr = state.editingLine!.attributes[index];
    state = state.copyWith(
      editingAttribute: attr,
      editingAttributeIndex: index,
    );
  }

  void updateEditingAttributeName(String name) {
    state = state.copyWith(
      editingAttribute: state.editingAttribute!.copyWith(title: name),
    );
  }

  void addPointToEditingAttribute() {
    final attr = state.editingAttribute;
    if (attr == null) return;

    final center = state.center; // ★ 画面中央の座標

    final updated = attr.copyWith(
      points: [...attr.points, center],
    );

    state = state.copyWith(editingAttribute: updated);
  }

  void removeLastPointFromEditingAttribute() {
    final points = [...state.editingAttribute!.points];
    if (points.isNotEmpty) points.removeLast();

    state = state.copyWith(
      editingAttribute: state.editingAttribute!.copyWith(points: points),
    );
  }

  void saveEditingAttribute() {
    final attr = state.editingAttribute!;
    final index = state.editingAttributeIndex;

    final line = state.editingLine!;
    final attrs = [...line.attributes];

    if (index == null) {
      attrs.add(attr);
    } else {
      attrs[index] = attr;
    }

    state = state.copyWith(
      editingLine: line.copyWith(attributes: attrs),
      editingAttribute: null,
      editingAttributeIndex: null,
    );
  }

  // ---------------------------------------------------------
  // 保存 / 読み込み
  // ---------------------------------------------------------
  Future<void> saveAllLines() async {
    await _repository.saveLines(state.savedLines);
  }

  Future<void> loadAllLines() async {
    final loaded = await _repository.loadLines();
    state = state.copyWith(savedLines: loaded);
  }
}