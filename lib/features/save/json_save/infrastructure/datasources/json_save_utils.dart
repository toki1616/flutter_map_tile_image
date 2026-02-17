import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SaveUtils {
  /// 保存フォルダの取得
  static Future<Directory> _getSaveFolder() async {
    Directory baseDir;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // PC：exe と同じ階層
      final exePath = Platform.resolvedExecutable; // exe のフルパス
      final exeDir = Directory(p.dirname(exePath));

      baseDir = Directory(p.join(exeDir.path, "SaveData"));
    } else {
      // スマホ：安全な領域
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

  /// JSON 保存
  static Future<void> save(String fileName, Map<String, dynamic> data) async {
    final path = await _getPath(fileName);
    final file = File(path);

    final jsonStr = const JsonEncoder.withIndent("  ").convert(data);
    await file.writeAsString(jsonStr);
  }

  /// JSON 読み込み
  static Future<Map<String, dynamic>?> load(String fileName) async {
    final path = await _getPath(fileName);
    final file = File(path);

    if (!await file.exists()) {
      return null;
    }

    final jsonStr = await file.readAsString();
    return jsonDecode(jsonStr);
  }
}
