import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/map_pin.dart';
import '../../domain/repositories/map_pin_repository.dart';
import '../state/map_pin_state.dart';

class MapPinController extends StateNotifier<MapPinState> {
  final MapPinRepository repository;

  MapPinController(this.repository) : super(const MapPinState()) {
    _load();
  }

  Future<void> _load() async {
    final pins = await repository.loadPins();
    state = state.copyWith(pins: pins);
  }

  Future<void> addPin(MapPin pin) async {
    final updated = [...state.pins, pin];
    state = state.copyWith(pins: updated);
    await repository.savePins(updated);
  }

  Future<void> updatePin(MapPin oldPin, MapPin newPin) async {
    final updated = state.pins.map((p) {
      return p == oldPin ? newPin : p;
    }).toList();

    state = state.copyWith(pins: updated);
    await repository.savePins(updated);
  }

  Future<void> deletePin(MapPin pin) async {
    final updated = state.pins.where((p) => p != pin).toList();
    state = state.copyWith(pins: updated);
    await repository.savePins(updated);
  }
}
