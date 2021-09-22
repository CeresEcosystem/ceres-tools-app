import 'package:ceres_locker_app/core/utils/default_value.dart';

class Pair {
  final int? id;
  final String? shortName;
  final String? fullName;
  final int? liquidityOrder;
  final double? liquidity;
  final double? xorLiquidity;
  final double? targetAssetLiquidity;
  final double? volume;

  Pair({
    this.id,
    this.shortName,
    this.fullName,
    this.liquidityOrder,
    this.liquidity,
    this.xorLiquidity,
    this.targetAssetLiquidity,
    this.volume,
  });

  factory Pair.fromJson(Map<String, dynamic> json) => Pair(
        id: getDefaultIntValue(json['id']),
        shortName: getDefaultStringValue(json['token']),
        fullName: getDefaultStringValue(json['full_name']),
        liquidityOrder: getDefaultIntValue(json['liquidity_order']),
        liquidity: getDefaultDoubleValue(json['liquidity']),
        xorLiquidity: getDefaultDoubleValue(json['xor_liq']),
        targetAssetLiquidity: getDefaultDoubleValue(json['target_asset_liq']),
        volume: getDefaultDoubleValue(json['volume']),
      );
}
