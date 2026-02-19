import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/mode_window_provider.dart';
import 'line_file_list_window.dart';
import 'line_file_editor_window.dart';
import 'line_attribute_editor_window.dart';

class EditorWindowSwitcher extends ConsumerWidget {
  const EditorWindowSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final window = ref.watch(editorWindowProvider);

    switch (window) {
      case EditorWindowType.none:
        return const SizedBox.shrink();

      case EditorWindowType.lineFileList:
        return const LineFileListWindow();

      case EditorWindowType.lineFileEditor:
        return const LineFileEditorWindow();

      case EditorWindowType.lineAttributeEditor:
        return const LineAttributeEditorWindow();
    }
  }
}
