import 'package:flutter/material.dart';

/// マップのフローティングアクションボタン一式
class MapFabButtons extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapFabButtons({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // ズームインボタン
              FloatingActionButton(
                heroTag: 'zoom_in_btn',
                onPressed: onZoomIn, // 親から渡された関数を実行
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 10),

              // ズームアウトボタン
              FloatingActionButton(
                heroTag: 'zoom_out_btn',
                onPressed: onZoomOut, // 親から渡された関数を実行
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
      ),
    );
  }
}