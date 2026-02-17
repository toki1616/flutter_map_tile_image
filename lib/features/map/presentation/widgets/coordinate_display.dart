import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/map_providers.dart';

class CoordinateDisplay extends ConsumerWidget {
  const CoordinateDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapControllerProvider);

    return Positioned(
      right: 10,
      top: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          "Lat: ${mapState.center.latitude.toStringAsFixed(6)}\n"
              "Lng: ${mapState.center.longitude.toStringAsFixed(6)}",
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}