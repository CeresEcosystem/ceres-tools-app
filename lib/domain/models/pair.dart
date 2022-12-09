import 'package:ceres_locker_app/core/utils/default_value.dart';

class Pair {
  final String? baseToken;
  final String? shortName;
  final String? fullName;
  final int? liquidityOrder;
  final double? liquidity;
  final double? baseAssetLiquidity;
  final double? targetAssetLiquidity;
  final double? volume;
  final double? lockedLiquidity;

  Pair({
    this.baseToken,
    this.shortName,
    this.fullName,
    this.liquidityOrder,
    this.liquidity,
    this.baseAssetLiquidity,
    this.targetAssetLiquidity,
    this.volume,
    this.lockedLiquidity,
  });

  factory Pair.fromJson(Map<String, dynamic> json) => Pair(
        baseToken: getDefaultStringValue(json['base_asset']),
        shortName: getDefaultStringValue(json['token']),
        fullName: getDefaultStringValue(json['full_name']),
        liquidityOrder: getDefaultIntValue(json['order']),
        liquidity: getDefaultDoubleValue(json['liquidity']),
        baseAssetLiquidity: getDefaultDoubleValue(json['base_asset_liq']),
        targetAssetLiquidity: getDefaultDoubleValue(json['target_asset_liq']),
        volume: getDefaultDoubleValue(json['volume']),
        lockedLiquidity: getDefaultDoubleValue(json['locked_liquidity']),
      );
}
