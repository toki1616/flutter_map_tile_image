import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/map_line.dart';

class MapState {
  final LatLng center;
  final double zoom;

  /// 通常のライン描画用（モード中にマップタップで追加される点）
  final List<LatLng> currentPoints;

  /// 保存済みのラインファイル一覧
  final List<MapLine> savedLines;

  /// モード
  final bool isLineMode;
  final bool isPolygonMode;

  /// 選択中のラインファイル
  final int? selectedLineIndex;

  /// 選択中の属性（区間）
  final int? selectedAttributeIndex;

  /// ラインファイル編集用
  final MapLine? editingLine;
  final int? editingLineIndex;

  /// 属性編集用
  final MapLineAttribute? editingAttribute;
  final int? editingAttributeIndex;

  const MapState({
    required this.center,
    required this.zoom,
    required this.currentPoints,
    required this.savedLines,
    required this.isLineMode,
    required this.isPolygonMode,
    required this.selectedLineIndex,
    required this.selectedAttributeIndex,
    required this.editingLine,
    required this.editingLineIndex,
    required this.editingAttribute,
    required this.editingAttributeIndex,
  });

  MapState copyWith({
    LatLng? center,
    double? zoom,
    List<LatLng>? currentPoints,
    List<MapLine>? savedLines,
    bool? isLineMode,
    bool? isPolygonMode,
    int? selectedLineIndex,
    int? selectedAttributeIndex,
    MapLine? editingLine,
    int? editingLineIndex,
    MapLineAttribute? editingAttribute,
    int? editingAttributeIndex,
  }) {
    return MapState(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      currentPoints: currentPoints ?? this.currentPoints,
      savedLines: savedLines ?? this.savedLines,
      isLineMode: isLineMode ?? this.isLineMode,
      isPolygonMode: isPolygonMode ?? this.isPolygonMode,
      selectedLineIndex: selectedLineIndex ?? this.selectedLineIndex,
      selectedAttributeIndex:
      selectedAttributeIndex ?? this.selectedAttributeIndex,
      editingLine: editingLine ?? this.editingLine,
      editingLineIndex: editingLineIndex ?? this.editingLineIndex,
      editingAttribute: editingAttribute ?? this.editingAttribute,
      editingAttributeIndex:
      editingAttributeIndex ?? this.editingAttributeIndex,
    );
  }

  factory MapState.initial() => MapState(
    center: const LatLng(35.681236, 139.767125),
    zoom: 6,
    currentPoints: const [],
    savedLines: const [],
    isLineMode: false,
    isPolygonMode: false,
    selectedLineIndex: null,
    selectedAttributeIndex: null,
    editingLine: null,
    editingLineIndex: null,
    editingAttribute: null,
    editingAttributeIndex: null,
  );
}

/// 現在描画すべきポイントを返す getter
extension MapStateX on MapState {
  List<LatLng> get linePoints {
    // 属性編集中 → editingAttribute の points を返す
    if (editingAttribute != null) {
      return editingAttribute!.points;
    }

    // ライン選択中 → その属性の points を返す
    if (selectedLineIndex != null && selectedAttributeIndex != null) {
      final line = savedLines[selectedLineIndex!];
      final attr = line.attributes[selectedAttributeIndex!];
      return attr.points;
    }

    // それ以外 → currentPoints（編集中のライン）
    return currentPoints;
  }
}
