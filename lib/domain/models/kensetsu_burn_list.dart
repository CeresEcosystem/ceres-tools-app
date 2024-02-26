import 'package:ceres_tools_app/domain/models/kensetsu_burn.dart';

class KensetsuBurnList {
  List<KensetsuBurn> _kensetsuBurns = [];

  KensetsuBurnList(this._kensetsuBurns);

  List<KensetsuBurn> get kensetsuBurns => _kensetsuBurns;

  factory KensetsuBurnList.fromJson(List<dynamic> json) {
    return KensetsuBurnList(
      json
          .map((e) => KensetsuBurn.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
