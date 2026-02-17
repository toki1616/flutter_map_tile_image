import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/map_providers.dart';
import 'package:flutter_map/flutter_map.dart';

class MapFabButtons extends ConsumerWidget {
  final MapController mapController;

  const MapFabButtons({super.key, required this.mapController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapControllerProvider);
    final mapCtrl = ref.read(mapControllerProvider.notifier);
    final modeWindowCtrl = ref.read(modeWindowVisibleProvider.notifier);

    // FAB の色をモードに応じて切り替える
    Color? _lineButtonColor() {
      if (mapState.isLineMode) return Colors.orange;   // ラインモード
      if (mapState.isPolygonMode) return Colors.green; // ポリゴンモード
      return null;                              // 通常
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ライン / ポリゴン モード選択ウィンドウを開くボタン
        FloatingActionButton(
          heroTag: "lineMode",
          backgroundColor: _lineButtonColor(),
          child: const Icon(Icons.timeline),
          onPressed: () {
            modeWindowCtrl.state = !modeWindowCtrl.state;
          },
        ),
        const SizedBox(height: 12),

        // ライン保存
        FloatingActionButton(
          heroTag: "saveLine",
          child: const Icon(Icons.save),
          onPressed: () async {
            await mapCtrl.saveCurrentLine();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("ラインを保存しました")),
            );
          },
        ),
        const SizedBox(height: 12),

        // ズームイン
        FloatingActionButton(
          heroTag: "zoomIn",
          child: const Icon(Icons.add),
          onPressed: () {
            mapController.move(
              mapState.center,
              mapState.zoom + 1,
            );
          },
        ),
        const SizedBox(height: 10),

        // ズームアウト
        FloatingActionButton(
          heroTag: "zoomOut",
          child: const Icon(Icons.remove),
          onPressed: () {
            mapController.move(
              mapState.center,
              mapState.zoom - 1,
            );
          },
        ),
      ],
    );
  }
}