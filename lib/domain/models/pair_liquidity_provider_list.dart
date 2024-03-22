import 'package:ceres_tools_app/domain/models/pair_liquidity_provider.dart';

class PairLiquidityProviderList {
  List<PairLiquidityProvider> _pairLiquidityProviders = [];

  PairLiquidityProviderList(this._pairLiquidityProviders);

  List<PairLiquidityProvider> get pairLiquidityProviders =>
      _pairLiquidityProviders;

  factory PairLiquidityProviderList.fromJson(List<dynamic> json) {
    return PairLiquidityProviderList(
      json
          .map((e) => PairLiquidityProvider.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
