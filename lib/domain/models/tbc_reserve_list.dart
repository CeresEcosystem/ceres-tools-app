import 'package:ceres_tools_app/domain/models/tbc_reserve.dart';

class TBCReserveList {
  List<TBCReserve> _tbcReserves = [];

  TBCReserveList(this._tbcReserves);

  List<TBCReserve> get tbcReserves => _tbcReserves;

  factory TBCReserveList.fromJson(List<dynamic> json) {
    return TBCReserveList(
      json.map((e) => TBCReserve.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
