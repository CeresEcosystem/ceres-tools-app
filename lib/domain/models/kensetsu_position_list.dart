import 'package:ceres_tools_app/domain/models/kensetsu_position.dart';

class KensetsuPositionList {
  final List<KensetsuPosition> _kensetsuPositions;

  const KensetsuPositionList(this._kensetsuPositions);

  List<KensetsuPosition> get kensetsuPositions => _kensetsuPositions.toList();

  factory KensetsuPositionList.fromJson(List<dynamic> json) {
    return KensetsuPositionList(
      json
          .map((e) => KensetsuPosition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
