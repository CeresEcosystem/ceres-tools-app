import 'package:ceres_tools_app/domain/models/pair_liquidity.dart';

class PairLiquidityList {
  List<PairLiquidity> _pairLiquidities = [];

  PairLiquidityList(this._pairLiquidities);

  List<PairLiquidity> get pairLiquidities => _pairLiquidities;

  factory PairLiquidityList.fromJson(List<dynamic> json) {
    return PairLiquidityList(
      json
          .map((e) => PairLiquidity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
