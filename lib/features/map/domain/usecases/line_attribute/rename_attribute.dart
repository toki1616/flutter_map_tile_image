import '../../entities/map_line.dart';

class RenameAttribute {
  const RenameAttribute();

  MapLine call(
      MapLine line, {
        required int index,
        required String newTitle,
      }) {
    if (index < 0 || index >= line.attributes.length) return line;

    final attrs = [...line.attributes];
    attrs[index] = attrs[index].copyWith(title: newTitle);

    return line.copyWith(attributes: attrs);
  }
}
