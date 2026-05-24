import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MapEditorMode {
  none,
  pointFileList,
  pointEditor,
}

final modeWindowProvider = StateProvider.autoDispose<MapEditorMode>((ref) {
  return MapEditorMode.none;
});