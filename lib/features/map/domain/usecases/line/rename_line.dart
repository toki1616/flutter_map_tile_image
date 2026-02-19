import '../../entities/map_line.dart';

class RenameLine {
  const RenameLine();

  List<MapLine> call(
      List<MapLine> lines, {
        required int index,
        required String newTitle,
      }) {
    if (index < 0 || index >= lines.length) return lines;

    final updated = [...lines];
    updated[index] = updated[index].copyWith(title: newTitle);
    return updated;
  }
}
