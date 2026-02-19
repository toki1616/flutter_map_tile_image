import '../../entities/map_line.dart';

class DeleteAttribute {
  const DeleteAttribute();

  MapLine call(MapLine line, int index) {
    if (index < 0 || index >= line.attributes.length) return line;

    final attrs = [...line.attributes]..removeAt(index);
    return line.copyWith(attributes: attrs);
  }
}
