import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'path_utils.dart';
import '../constants/save_file_name.dart';

class JsonSaveUtils {
  /// --------------------------------------------------------
  /// Enumベースのデータの保存・読み込み
  /// --------------------------------------------------------

  /// JSON に変換して保存する
  static Future<void> save(SaveFileName type, dynamic data, {String? datasetPath}) async {
    final path = await PathUtils.getJsonFilePath(type, datasetPath: datasetPath);
    log("SaveUtils.save() 開始: fileName=${type.fileName}");
    await _writeToFile(path, data);
  }

  /// JSON 読み込み
  static Future<dynamic> load(SaveFileName type, {String? datasetPath}) async {
    final path = await PathUtils.getJsonFilePath(type, datasetPath: datasetPath);
    log("SaveUtils.load() 開始: fileName=${type.fileName}");
    return await _readFromFile(path);
  }

  /// ファイルを削除する
  static Future<void> delete(SaveFileName type, {String? datasetPath}) async {
    final path = await PathUtils.getJsonFilePath(type, datasetPath: datasetPath);
    log("SaveUtils.delete() 開始: fileName=${type.fileName}");
    await _deleteFile(path);
  }

  /// --------------------------------------------------------
  /// 内部の共通ファイル操作ロジック（ログ出力付き）
  /// --------------------------------------------------------

  static Future<void> _writeToFile(String path, dynamic data) async {
    final file = File(path);
    log("保存先パス: $path");

    try {
      final jsonReady = _convertToJson(data);
      final jsonStr = const JsonEncoder.withIndent("  ").convert(jsonReady);

      await file.writeAsString(jsonStr);
      log("保存完了: $path");
    } catch (e, stack) {
      log("SaveUtils._writeToFile() でエラー発生: $e\n$stack");
    }
  }

  static Future<dynamic> _readFromFile(String path) async {
    final file = File(path);
    log("読み込みパス: $path");

    try {
      if (!await file.exists()) {
        log("ファイルが存在しません: $path");
        return null;
      }

      final jsonStr = await file.readAsString();
      final decoded = jsonDecode(jsonStr);

      log("読み込み完了: $path");
      return decoded;
    } catch (e, stack) {
      log("SaveUtils._readFromFile() でエラー発生: $e\n$stack");
      return null;
    }
  }

  static Future<void> _deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      log("削除完了: $path");
    } else {
      log("削除対象のファイルが存在しません: $path");
    }
  }

  /// --------------------------------------------------------
  /// JSON 変換ユーティリティ
  /// --------------------------------------------------------

  /// 自動 JSON 化（Map / List / toJson() 対応）
  static dynamic _convertToJson(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      return data.map((key, value) => MapEntry(key, _convertToJson(value)));
    }
    if (data is List) {
      return data.map((e) => _convertToJson(e)).toList();
    }
    if (_hasToJson(data)) {
      return _convertToJson(data.toJson());
    }
    if (data is String || data is num || data is bool) {
      return data;
    }

    throw Exception("SaveUtils: JSON に変換できない型です → ${data.runtimeType}");
  }

  /// toJson() を持っているかチェック
  static bool _hasToJson(dynamic obj) {
    try {
      return obj.toJson is Function;
    } catch (_) {
      return false;
    }
  }
}