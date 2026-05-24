import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/map_point_provider.dart';

class MapPointEditorWindow extends ConsumerStatefulWidget {
  const MapPointEditorWindow({super.key});

  @override
  ConsumerState<MapPointEditorWindow> createState() => _MapPointEditorWindowState();
}

class _MapPointEditorWindowState extends ConsumerState<MapPointEditorWindow> {
  late final TextEditingController _titleController;
  late final TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    final initialPoint = ref.read(mapPointProvider).editingPoint;
    _titleController = TextEditingController(text: initialPoint?.title ?? "");
    _memoController = TextEditingController(text: initialPoint?.memo ?? "");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pointState = ref.watch(mapPointProvider);
    final pointCtrl = ref.read(mapPointProvider.notifier);
    final point = pointState.editingPoint;

    if (point == null) return const SizedBox.shrink();

    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 280,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pointState.editingPointIndex == null ? "新規ポイントの登録" : "ポイントの編集",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              // 名前入力
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "名前",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onChanged: pointCtrl.updateTitle,
              ),
              const SizedBox(height: 12),

              // メモ入力
              TextField(
                controller: _memoController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "メモ",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onChanged: pointCtrl.updateMemo,
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "座標:\n${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero, // ボタンの最小サイズ制約をクリアしてコンパクトにする
                    ),
                    onPressed: pointCtrl.updateEditingPointPosition, // 位置更新ロジックを呼び出す
                    icon: const Icon(Icons.my_location, size: 14),
                    label: const Text("ここに移動", style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: pointCtrl.cancelEditing,
                    child: const Text("キャンセル"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("入力エラー"),
                            content: const Text("ポイントの名前を入力してください。"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      pointCtrl.saveEditingPoint();
                    },
                    child: const Text("保存"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}