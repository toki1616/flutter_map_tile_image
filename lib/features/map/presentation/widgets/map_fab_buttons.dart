import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/map_point_provider.dart';
import '../../application/providers/mode_window_provider.dart';

class MapFabButtons extends ConsumerWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapFabButtons({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorMode = ref.watch(modeWindowProvider);
    final isPointSelected = editorMode == MapEditorMode.pointEditor;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "btn_zoom_in",
              onPressed: onZoomIn,
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: "btn_zoom_out",
              onPressed: onZoomOut,
              child: const Icon(Icons.remove),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: "btn_add_point",
              // 選択中（ON）はColors.redAccent、通常時（OFF）は他のボタンと同じ（nullでデフォルト色）
              backgroundColor: isPointSelected ? Colors.blue : null,
              foregroundColor: isPointSelected ? Colors.white : null,
              // 抜粋
              onPressed: () {
                final currentMode = ref.read(modeWindowProvider);
                if (currentMode == MapEditorMode.pointFileList || currentMode == MapEditorMode.pointEditor) {
                  // 既にポイント関連が開いていれば閉じる（トグル）
                  ref.read(modeWindowProvider.notifier).state = MapEditorMode.none;
                  ref.read(mapPointProvider.notifier).cancelEditing();
                } else {
                  // 開いていなければ「一覧」を開く
                  ref.read(modeWindowProvider.notifier).state = MapEditorMode.pointFileList;
                }
              },
              child: const Icon(Icons.add_location_alt),
            ),
          ],
        ),
      ),
    );
  }
}