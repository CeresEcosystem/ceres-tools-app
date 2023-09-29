import 'package:ceres_locker_app/domain/models/swap.dart';

class SwapList {
  List<Swap> _swaps = [];

  SwapList(this._swaps);

  List<Swap> get swaps => _swaps;

  factory SwapList.fromJson(List<dynamic> json) {
    return SwapList(
      json.map((e) => Swap.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
