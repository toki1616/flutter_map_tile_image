import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/map_providers.dart';
import '../../../application/providers/mode_window_provider.dart';
import '../../../../ui/widgets/reusable_list_view.dart';

class LineAttributeEditorWindow extends ConsumerWidget {
  const LineAttributeEditorWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapControllerProvider);
    final mapCtrl = ref.read(mapControllerProvider.notifier);
    final editorCtrl = ref.read(editorWindowProvider.notifier);

    final editingAttr = mapState.editingAttribute!;
    final editingIndex = mapState.editingAttributeIndex;

    return Positioned(
      top: 80,
      left: 20,
      width: 400,
      height: 420,
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
              Text(
                editingIndex == null ? "ライン作成" : "ライン編集",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              TextField(
                decoration: const InputDecoration(
                  labelText: "属性名",
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: editingAttr.title),
                onChanged: mapCtrl.updateEditingAttributeName,
              ),

              const SizedBox(height: 16),
              const Divider(),

              // 頂点一覧（ReusableListView）
              ReusableListView(
                itemCount: editingAttr.points.length,
                itemBuilder: (context, index) {
                  final p = editingAttr.points[index];
                  return ListTile(
                    title: Text("(${p.latitude}, ${p.longitude})"),
                  );
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: mapCtrl.addPointToEditingAttribute,
                    child: const Text("頂点追加"),
                  ),
                  ElevatedButton(
                    onPressed: mapCtrl.removeLastPointFromEditingAttribute,
                    child: const Text("最後を削除"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      mapCtrl.cancelEditingAttribute();
                      editorCtrl.state = EditorWindowType.lineFileEditor;
                    },
                    child: const Text("戻る"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      mapCtrl.saveEditingAttribute();
                      editorCtrl.state = EditorWindowType.lineFileEditor;
                    },
                    child: const Text("保存"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
