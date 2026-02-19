import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SaveUtils {
  /// 保存フォルダの取得
  static Future<Directory> _getSaveFolder() async {
    Directory baseDir;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final exePath = Platform.resolvedExecutable;
      final exeDir = Directory(p.dirname(exePath));
      baseDir = Directory(p.join(exeDir.path, "SaveData"));
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      baseDir = Directory(p.join(appDir.path, "SaveData"));
    }

    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }

    return baseDir;
  }

  /// フルパス生成
  static Future<String> _getPath(String fileName) async {
    final folder = await _getSaveFolder();
    return p.join(folder.path, "$fileName.json");
  }

  /// JSON に変換して保存する
  /// JSON に変換して保存する
  static Future<void> save(String fileName, dynamic data) async {
    final path = await _getPath(fileName);
    final file = File(path);

    log("💾 SaveUtils.save() 開始: fileName=$fileName");
    log("📂 保存先パス: $path");

    try {
      final jsonReady = _convertToJson(data);
      log("📄 保存する JSON オブジェクト: $jsonReady");

      final jsonStr = const JsonEncoder.withIndent("  ").convert(jsonReady);
      log("📝 JSON 文字列:\n$jsonStr");

      await file.writeAsString(jsonStr);

      log("✅ 保存完了: $fileName");

    } catch (e, stack) {
      log("❌ SaveUtils.save() でエラー発生: $e");
      log("📌 STACK TRACE:\n$stack");

      // 必要なら例外を再スローして上位に通知
      // throw e;
    }
  }

  /// JSON 読み込み
  /// JSON 読み込み
  static Future<dynamic> load(String fileName) async {
    final path = await _getPath(fileName);
    final file = File(path);

    log("📥 SaveUtils.load() 開始: fileName=$fileName");
    log("📂 読み込みパス: $path");

    try {
      if (!await file.exists()) {
        log("⚠️ ファイルが存在しません: $path");
        return null;
      }

      final jsonStr = await file.readAsString();
      log("📄 読み込んだ JSON 文字列:\n$jsonStr");

      final decoded = jsonDecode(jsonStr);
      log("📌 デコード結果: $decoded");

      log("✅ 読み込み完了: $fileName");
      return decoded;

    } catch (e, stack) {
      log("❌ SaveUtils.load() でエラー発生: $e");
      log("📌 STACK TRACE:\n$stack");

      // 必要なら上位に例外を投げる
      // throw e;

      return null;
    }
  }

  /// 自動 JSON 化（Map / List / toJson() 対応）
  static dynamic _convertToJson(dynamic data) {
    if (data == null) return null;

    // Map の場合
    if (data is Map) {
      return data.map((key, value) => MapEntry(key, _convertToJson(value)));
    }

    // List の場合
    if (data is List) {
      return data.map((e) => _convertToJson(e)).toList();
    }

    // toJson() を持つオブジェクト
    if (_hasToJson(data)) {
      return _convertToJson(data.toJson());
    }

    // プリミティブ型（String, int, double, bool）
    if (data is String ||
        data is num ||
        data is bool) {
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
