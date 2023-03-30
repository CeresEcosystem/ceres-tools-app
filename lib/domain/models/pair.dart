import 'package:ceres_locker_app/core/utils/default_value.dart';

class Pair {
  final String? baseToken;
  final String? shortName;
  final String? fullName;
  final double? liquidity;
  final double? baseAssetLiquidity;
  final double? targetAssetLiquidity;
  final double? volume;
  final double? lockedLiquidity;

  Pair({
    this.baseToken,
    this.shortName,
    this.fullName,
    this.liquidity,
    this.baseAssetLiquidity,
    this.targetAssetLiquidity,
    this.volume,
    this.lockedLiquidity,
  });

  factory Pair.fromJson(Map<String, dynamic> json) => Pair(
        baseToken: getDefaultStringValue(json['baseAsset']),
        shortName: getDefaultStringValue(json['token']),
        fullName: getDefaultStringValue(json['tokenFullName']),
        liquidity: getDefaultDoubleValue(json['liquidity']),
        baseAssetLiquidity: getDefaultDoubleValue(json['baseAssetLiq']),
        targetAssetLiquidity: getDefaultDoubleValue(json['targetAssetLiq']),
        volume: getDefaultDoubleValue(json['volume']),
        lockedLiquidity: getDefaultDoubleValue(json['lockedLiquidity']),
      );
}
