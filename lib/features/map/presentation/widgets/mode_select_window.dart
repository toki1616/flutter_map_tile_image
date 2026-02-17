import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/map_providers.dart';

class ModeSelectWindow extends ConsumerWidget {
  const ModeSelectWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapCtrl = ref.read(mapControllerProvider.notifier);
    final modeWindowVisible = ref.watch(modeWindowVisibleProvider);
    final modeWindowCtrl = ref.read(modeWindowVisibleProvider.notifier);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      top: modeWindowVisible ? 20 : -120,
      left: 20,
      right: 20,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "モードを選択",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      mapCtrl.toggleLineMode();
                      modeWindowCtrl.state = false;
                    },
                    child: const Text("ライン"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      mapCtrl.togglePolygonMode();
                      modeWindowCtrl.state = false;
                    },
                    child: const Text("ポリゴン"),
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