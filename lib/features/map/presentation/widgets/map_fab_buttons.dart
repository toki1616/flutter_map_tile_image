import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_tile_image/features/map/presentation/widgets/pin/pin_add_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../application/providers/map_providers.dart';
import '../../application/providers/mode_window_provider.dart';
import '../../application/providers/map_pin_providers.dart';
import '../../domain/entities/map_pin.dart';


class MapFabButtons extends ConsumerWidget {
  final MapController mapController;

  const MapFabButtons({super.key, required this.mapController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapControllerProvider);
    final mapCtrl = ref.read(mapControllerProvider.notifier);

    final pinCtrl = ref.read(mapPinControllerProvider.notifier); // ← ★ ピン用
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
          heroTag: "addPin",
          child: const Icon(Icons.location_pin),
          onPressed: () {
            final center = mapState.center; // ← 現在の地図中央座標

            showDialog(
              context: context,
              builder: (_) => PinAddDialog(
                point: LatLng(center.latitude, center.longitude),
                pin: null, // ← 新規追加モード
              ),
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
        const SizedBox(height: 10),

        FloatingActionButton(
          heroTag: "pickTileFolder",
          child: const Icon(Icons.folder),
          onPressed: () async {
            // ★ Androidの場合はストレージ権限を要求する
            if (Platform.isAndroid) {
              // Android 11以降は manageExternalStorage、10以前は storage を要求
              var status = await Permission.manageExternalStorage.status;
              if (!status.isGranted) {
                await Permission.manageExternalStorage.request();
              }

              var legacyStatus = await Permission.storage.status;
              if (!legacyStatus.isGranted) {
                await Permission.storage.request();
              }

              // 権限が拒否された場合は処理を中断
              if (!await Permission.manageExternalStorage.isGranted &&
                  !await Permission.storage.isGranted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("ストレージへのアクセス権限が必要です")),
                );
                return;
              }
            }

            // 元のファイルピッカーの処理
            final path = await FilePicker.platform.getDirectoryPath();
            if (path != null) {
              ref.read(tileDirectoryProvider.notifier).state = path;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("タイルフォルダを選択しました: $path")),
              );
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
