import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/map_providers.dart';
import '../../../application/providers/mode_window_provider.dart';
import '../../../../ui/widgets/reusable_list_view.dart';

class LineFileListWindow extends ConsumerWidget {
  const LineFileListWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapControllerProvider);
    final mapCtrl = ref.read(mapControllerProvider.notifier);
    final editorCtrl = ref.read(editorWindowProvider.notifier);

    final selected = mapState.selectedLineIndex;

    return Positioned(
      top: 80,
      left: 20,
      width: 280,
      height: 300,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ラインファイル一覧",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      mapCtrl.startNewLineFile();
                      editorCtrl.state = EditorWindowType.lineFileEditor;
                    },
                    child: const Text("新規"),
                  ),
                  ElevatedButton(
                    onPressed: selected == null
                        ? null
                        : () {
                      mapCtrl.startEditLineFile(selected);
                      editorCtrl.state = EditorWindowType.lineFileEditor;
                    },
                    child: const Text("編集"),
                  ),
                  ElevatedButton(
                    onPressed: selected == null
                        ? null
                        : () {
                      mapCtrl.deleteLine(selected);
                    },
                    child: const Text("削除"),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),

              ReusableListView(
                itemCount: mapState.savedLines.length,
                itemBuilder: (context, index) {
                  final line = mapState.savedLines[index];
                  return ListTile(
                    title: Text(line.title),
                    selected: selected == index,
                    onTap: () => mapCtrl.selectLine(index),
                  );
                },
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    editorCtrl.state = EditorWindowType.none;
                  },
                  child: const Text("閉じる"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
