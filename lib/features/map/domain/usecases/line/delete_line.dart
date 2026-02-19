import '../../entities/map_line.dart';

class DeleteLine {
  const DeleteLine();

  List<MapLine> call(List<MapLine> currentLines, int index) {
    if (index < 0 || index >= currentLines.length) return currentLines;
    final updated = [...currentLines]..removeAt(index);
    return updated;
  }
}
