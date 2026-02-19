import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/map_providers.dart';
import '../../../application/providers/mode_window_provider.dart';

import '../../../../ui/widgets/reusable_list_view.dart';

class LineFileEditorWindow extends ConsumerWidget {
  const LineFileEditorWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapControllerProvider);
    final mapCtrl = ref.read(mapControllerProvider.notifier);
    final editorCtrl = ref.read(editorWindowProvider.notifier);

    final selected = mapState.selectedAttributeIndex;
    final editingLine = mapState.editingLine;
    if (editingLine == null) return const SizedBox.shrink();

    return Positioned(
      top: 80,
      left: 20,
      width: 320,
      height: 480,
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
              const Text("ラインファイル作成",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              //const SizedBox(height: 16),

              TextField(
                decoration: const InputDecoration(labelText: "ファイル名"),
                controller: TextEditingController(text: editingLine.title),
                onChanged: mapCtrl.updateEditingLineFileName,
              ),

              //const SizedBox(height: 12),

              Row(
                children: [
                  const Text("線の色："),
                  const SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: editingLine.lineColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final color = await showDialog<Color>(
                        context: context,
                        builder: (_) => _ColorPickerDialog(
                          initialColor: editingLine.lineColor,
                        ),
                      );
                      if (color != null) {
                        mapCtrl.updateEditingLineColor(color);
                      }
                    },
                    child: const Text("選択"),
                  ),
                ],
              ),

              //const SizedBox(height: 12),

              Row(
                children: [
                  const Text("線の太さ："),
                  const SizedBox(width: 12),

                  Expanded(
                    child: DropdownButtonFormField<double>(
                      value: editingLine.lineWidth,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: List.generate(
                        15,
                            (i) => DropdownMenuItem(
                          value: (i + 1).toDouble(),
                          child: Text("${i + 1}px"),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          mapCtrl.updateEditingLineWidth(value);
                        }
                      },
                    ),
                  ),
                ],
              ),

              //const SizedBox(height: 16),

              const Text("ライン一覧"),

              ReusableListView(
                itemCount: editingLine.attributes.length,
                itemBuilder: (context, index) {
                  final attr = editingLine.attributes[index];
                  return ListTile(
                    title: Text(attr.title),
                    selected: selected == index,
                    onTap: () => mapCtrl.selectAttribute(index),
                  );
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      mapCtrl.startNewAttribute();
                      editorCtrl.state =
                          EditorWindowType.lineAttributeEditor;
                    },
                    child: const Text("ライン追加"),
                  ),
                  ElevatedButton(
                    onPressed: selected == null
                        ? null
                        : () {
                      mapCtrl.startEditingAttribute(selected);
                      editorCtrl.state =
                          EditorWindowType.lineAttributeEditor;
                    },
                    child: const Text("ライン編集"),
                  ),
                  ElevatedButton(
                    onPressed: selected == null
                        ? null
                        : () {
                      mapCtrl.deleteAttribute(selected);
                    },
                    child: const Text("ライン削除"),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      mapCtrl.cancelEditingLineFile();
                      editorCtrl.state = EditorWindowType.lineFileList;
                    },
                    child: const Text("キャンセル"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      mapCtrl.saveEditingLineFile();
                      editorCtrl.state = EditorWindowType.lineFileList;
                    },
                    child: const Text("確定"),
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

/// 色選択ダイアログ
class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const _ColorPickerDialog({required this.initialColor});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("色を選択"),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: Colors.primaries.map((c) {
          return GestureDetector(
            onTap: () => setState(() => selected = c),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: selected == c ? Colors.black : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("キャンセル"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selected),
          child: const Text("決定"),
        ),
      ],
    );
  }
}
