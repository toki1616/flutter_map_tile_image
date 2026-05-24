import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import '../../../application/providers/map_point_provider.dart';
import '../../../application/providers/mode_window_provider.dart';

class MapPointListWindow extends ConsumerWidget {
  const MapPointListWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointState = ref.watch(mapPointProvider);
    final pointCtrl = ref.read(mapPointProvider.notifier);
    final editorCtrl = ref.read(modeWindowProvider.notifier);

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final safeHeight = mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom;

    final selected = pointState.selectedPointIndex;

    final double windowWidth = min(280.0, screenWidth - 40);
    final double windowHeight = min(350.0, safeHeight * 0.75);

    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(0, 40),
      padding: const EdgeInsets.symmetric(horizontal: 12),
    );

    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: SizedBox(
            width: windowWidth,
            height: windowHeight,
            child: Material(
              color: Colors.white,
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ポイント一覧",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {
                            pointCtrl.startNewPoint();
                          },
                          child: const Text("新規"),
                        ),
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: selected == null ? null : () {
                            pointCtrl.startEditPoint(selected);
                          },
                          child: const Text("編集"),
                        ),
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: selected == null ? null : () {
                            pointCtrl.deletePoint(selected);
                          },
                          child: const Text("削除"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListView.builder(
                          itemCount: pointState.savedPoints.length,
                          itemBuilder: (context, index) {
                            final point = pointState.savedPoints[index];
                            final isSelected = selected == index;
                            final title = point.title.isEmpty ? "名称未設定ポイント" : point.title;

                            return Material(
                              color: isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.transparent,
                              child: InkWell(
                                onTap: () => pointCtrl.selectPoint(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // 表示/非表示ボタン
                                        Container(
                                          width: 60,
                                          margin: const EdgeInsets.symmetric(vertical: 4),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: point.isVisible ? Colors.blue : Colors.grey.shade300,
                                              foregroundColor: point.isVisible ? Colors.white : Colors.grey.shade700,
                                              padding: EdgeInsets.zero,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                            onPressed: () => pointCtrl.toggleVisibility(index),
                                            child: Text(
                                              point.isVisible ? "表示" : "非表示",
                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // タイトル
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            child: Text(
                                              title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                color: isSelected ? Colors.blue.shade700 : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          editorCtrl.state = MapEditorMode.none; // 閉じる
                        },
                        child: const Text("閉じる"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}