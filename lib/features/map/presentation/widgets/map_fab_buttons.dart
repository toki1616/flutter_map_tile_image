import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../application/providers/map_providers.dart';
import '../../application/providers/mode_window_provider.dart';

class MapFabButtons extends ConsumerWidget {
  final MapController mapController;

  const MapFabButtons({super.key, required this.mapController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapControllerProvider);
    final mapCtrl = ref.read(mapControllerProvider.notifier);
    final modeWindowCtrl = ref.read(modeWindowVisibleProvider.notifier);

    Color? _lineButtonColor() {
      if (mapState.isLineMode) return Colors.orange;
      if (mapState.isPolygonMode) return Colors.green;
      return null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "lineMode",
          backgroundColor: _lineButtonColor(),
          child: const Icon(Icons.timeline),
          onPressed: () {
            modeWindowCtrl.state = !modeWindowCtrl.state;
          },
        ),
        const SizedBox(height: 12),

        FloatingActionButton(
          heroTag: "saveLine",
          child: const Icon(Icons.save),
          onPressed: () async {
            await mapCtrl.saveAllLines();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("ラインを保存しました")),
            );
          },
        ),
        const SizedBox(height: 12),

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
