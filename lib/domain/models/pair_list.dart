import 'package:ceres_locker_app/domain/models/pair.dart';

class PairList {
  final List<Pair>? _pairs;

  const PairList(this._pairs);

  List<Pair>? get pairs => _pairs;

  factory PairList.fromJson(List<dynamic> json) {
    return PairList(
      json.map((e) => Pair.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
