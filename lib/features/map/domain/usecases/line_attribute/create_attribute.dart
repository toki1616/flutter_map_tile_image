import '../../entities/map_line.dart';

class CreateAttribute {
  const CreateAttribute();

  MapLine call(MapLine line) {
    final newAttr = MapLineAttribute(
      title: '区間 ${line.attributes.length + 1}',
      points: const [],
    );

    return line.copyWith(
      attributes: [...line.attributes, newAttr],
    );
  }
}
