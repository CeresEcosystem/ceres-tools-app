import 'package:ceres_tools_app/domain/models/burn.dart';

class BurnList {
  List<Burn> _burns = [];

  BurnList(this._burns);

  List<Burn> get burns => _burns;

  factory BurnList.fromJson(List<dynamic> json) {
    return BurnList(
      json.map((e) => Burn.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
