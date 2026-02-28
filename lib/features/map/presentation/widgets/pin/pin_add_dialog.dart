import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../application/controllers/map_pin_controller.dart';
import '../../../application/providers/map_pin_providers.dart';
import '../../../domain/entities/map_pin.dart';

class PinAddDialog extends ConsumerWidget {
  final MapPin? pin; // null → 新規追加、非 null → 編集
  final LatLng point;

  const PinAddDialog({
    super.key,
    required this.point,
    this.pin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: pin?.data ?? "");
    final createdAt = pin?.createdAt ?? DateTime.now();

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // タイトル
                  Text(
                    pin == null ? "ピンを追加" : "ピンを編集",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // メモ入力欄
                  TextField(
                    controller: controller,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "メモ",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 登録日時
                  Text("登録日時: ${createdAt.toLocal()}"),
                  const SizedBox(height: 8),

                  // 緯度経度
                  Text("緯度: ${point.latitude.toStringAsFixed(6)}"),
                  Text("経度: ${point.longitude.toStringAsFixed(6)}"),

                  const SizedBox(height: 16),

                  // ボタン
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("キャンセル"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final newPin = MapPin(
                            data: controller.text,
                            createdAt: createdAt,
                            point: point,
                          );

                          final notifier =
                          ref.read(mapPinControllerProvider.notifier);

                          if (pin == null) {
                            notifier.addPin(newPin);
                          } else {
                            notifier.updatePin(pin!, newPin);
                          }

                          Navigator.pop(context);
                        },
                        child: Text(pin == null ? "OK" : "更新"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}