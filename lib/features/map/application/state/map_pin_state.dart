import '../../domain/entities/map_pin.dart';

class MapPinState {
  final List<MapPin> pins;

  const MapPinState({this.pins = const []});

  MapPinState copyWith({List<MapPin>? pins}) {
    return MapPinState(
      pins: pins ?? this.pins,
    );
  }
}
