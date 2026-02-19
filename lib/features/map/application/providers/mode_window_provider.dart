import 'package:flutter_riverpod/flutter_riverpod.dart';

final modeWindowVisibleProvider = StateProvider<bool>((ref) => false);

enum EditorWindowType {
  none,
  lineFileList,      // 既存の ModeActionWindow
  lineFileEditor,    // ラインファイル作成
  lineAttributeEditor, // ライン作成
}

final editorWindowProvider = StateProvider<EditorWindowType>((ref) {
  return EditorWindowType.none;
});
