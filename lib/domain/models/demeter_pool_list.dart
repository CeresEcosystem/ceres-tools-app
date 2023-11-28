import 'package:ceres_tools_app/domain/models/demeter_pool.dart';

class DemeterPoolList {
  final List<DemeterPool>? _demeterPools;

  const DemeterPoolList(this._demeterPools);

  List<DemeterPool>? get demeterPools => _demeterPools;

  factory DemeterPoolList.fromJson(List<dynamic> json) {
    return DemeterPoolList(
      json.map((e) => DemeterPool.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
