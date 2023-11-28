import 'package:ceres_tools_app/domain/models/demeter_farm.dart';

class DemeterFarmList {
  final List<DemeterFarm>? _demeterFarms;

  const DemeterFarmList(this._demeterFarms);

  List<DemeterFarm>? get demeterFarms => _demeterFarms;

  factory DemeterFarmList.fromJson(List<dynamic> json) {
    return DemeterFarmList(
      json.map((e) => DemeterFarm.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
