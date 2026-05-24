import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/save_file_name.dart';

class PathUtils {
  /// --------------------------------------------------------
  /// 【共通ロジック】指定したベースパス配下のサブフォルダを安全に取得・作成する
  /// datasetPath が null（未指定）の場合は、アプリのデフォルト保存領域を使用します。
  /// --------------------------------------------------------
  static Future<Directory> _getDatasetSubFolder(
      List<String> pathSegments, {
        String? datasetPath,
      }) async {
    // フォルダ指定がない場合は、これまでのアプリ標準フォルダを親にする
    final String basePath = datasetPath ?? (await getAppBaseSaveFolder()).path;

    // ベースパスと、指定されたサブパスをすべて結合
    final fullPath = p.joinAll([basePath, ...pathSegments]);
    final dir = Directory(fullPath);

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// --------------------------------------------------------
  /// 【系統1】これまでのアプリ固有の保存フォルダ (設定ファイル用等)
  /// --------------------------------------------------------
  static Future<Directory> getAppBaseSaveFolder() async {
    Directory rootDir;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final exePath = Platform.resolvedExecutable;
      rootDir = Directory(p.dirname(exePath));
    } else if (Platform.isAndroid) {
      // Android: アプリ削除で消え、PCからも見える getExternalStorageDirectory を使用
      final externalDir = await getExternalStorageDirectory();
      rootDir = externalDir ?? await getApplicationDocumentsDirectory();
    } else {
      // iOS 等のその他プラットフォーム
      rootDir = await getApplicationDocumentsDirectory();
    }

    final baseDir = Directory(p.join(rootDir.path, "save_data"));
    if (!await baseDir.exists()) await baseDir.create(recursive: true);

    return baseDir;
  }

  /// --------------------------------------------------------
  /// JSON用のフルパスを生成する (Enumを見て自動分岐)
  /// --------------------------------------------------------
  static Future<String> getJsonFilePath(SaveFileName type, {String? datasetPath}) async {
    if (type.location == SaveLocation.appBase) {
      final folder = await getAppBaseSaveFolder();
      return p.join(folder.path, "${type.fileName}.json");
    } else {
      // 共通メソッドを使ってフォルダを取得 (引数渡し)
      final dir = await _getDatasetSubFolder(["save_data", type.subDirectory], datasetPath: datasetPath);
      return p.join(dir.path, "${type.fileName}.json");
    }
  }
}