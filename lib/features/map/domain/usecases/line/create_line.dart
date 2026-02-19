import '../../entities/map_line.dart';

class CreateLine {
  const CreateLine();

  List<MapLine> call(List<MapLine> currentLines) {
    final newLine = MapLine(
      title: 'ルート ${currentLines.length + 1}',
      attributes: const [],
    );
    return [...currentLines, newLine];
  }
}
