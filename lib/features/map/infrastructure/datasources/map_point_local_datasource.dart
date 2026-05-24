import 'dart:convert';
import 'dart:developer';

import '../../../shared/utils/json_save_utils.dart';
import '../../../shared/constants/save_file_name.dart';

import '../../domain/entities/map_point.dart';

class MapPointLocalDataSource {
  /// --------------------------------------------------------
  /// ポイント一覧を JSON ファイルとして保存する
  /// --------------------------------------------------------
  Future<void> save(List<MapPoint> points) async {
    try {
      // SaveUtils に Enum(points) とデータのリストを渡すだけで、
      // 内部で自動的に toJson() が呼ばれて保存されます。
      await JsonSaveUtils.save(SaveFileName.points, points);
      log("MapPointLocalDataSource: ポイントの保存に成功しました（${points.length}件）");
    } catch (e, stack) {
      log("MapPointLocalDataSource: 保存エラー -> $e\n$stack");
    }
  }

  /// --------------------------------------------------------
  /// JSON ファイルからポイント一覧を読み込んで復元する
  /// --------------------------------------------------------
  Future<List<MapPoint>> load() async {
    try {
      // SaveUtils からデータを読み込む
      final data = await JsonSaveUtils.load(SaveFileName.points);

      // データが存在しない（初回起動など）場合は空のリストを返す
      if (data == null) {
        log("MapPointLocalDataSource: 保存データなし（空リストを返します）");
        return [];
      }

      // JSON のリストを MapPoint エンティティのリストに変換
      final jsonList = data as List;
      final loadedPoints = jsonList
          .map((e) => MapPoint.fromJson(e as Map<String, dynamic>))
          .toList();

      log("MapPointLocalDataSource: ポイントの読み込みに成功しました（${loadedPoints.length}件）");
      return loadedPoints;

    } catch (e, stack) {
      log("MapPointLocalDataSource: パースエラー -> $e\n$stack");
      return []; // データが壊れている場合はクラッシュさせず空リストにする
    }
  }
}