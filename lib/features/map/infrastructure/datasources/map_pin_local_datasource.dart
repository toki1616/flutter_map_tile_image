import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/map_pin.dart';

class MapPinLocalDatasource {
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/pins.json");
  }

  Future<List<MapPin>> loadPins() async {
    try {
      final file = await _getFile();
      if (!file.existsSync()) return [];

      final jsonStr = await file.readAsString();
      final list = json.decode(jsonStr) as List;

      return list.map((e) => MapPin.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> savePins(List<MapPin> pins) async {
    final file = await _getFile();
    final jsonStr = json.encode(pins.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonStr);
  }
}
