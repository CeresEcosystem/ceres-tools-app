import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';

class Pair {
  final String? baseToken;
  final String? shortName;
  final String? fullName;
  final double? liquidity;
  final double? baseAssetLiquidity;
  final double? targetAssetLiquidity;
  final double? volume;
  final Map<String, dynamic>? volumes;
  final double? lockedLiquidity;
  final String? tokenAssetId;
  final String? baseAssetId;
  String imageExtension = kImageExtension;

  Pair({
    this.baseToken,
    this.shortName,
    this.fullName,
    this.liquidity,
    this.baseAssetLiquidity,
    this.targetAssetLiquidity,
    this.volume,
    this.volumes,
    this.lockedLiquidity,
    this.tokenAssetId,
    this.baseAssetId,
  });

  factory Pair.fromJson(Map<String, dynamic> json) => Pair(
        baseToken: getDefaultStringValue(json['baseAsset']),
        shortName: getDefaultStringValue(json['token']),
        fullName: getDefaultStringValue(json['tokenFullName']),
        liquidity: getDefaultDoubleValue(json['liquidity']),
        baseAssetLiquidity: getDefaultDoubleValue(json['baseAssetLiq']),
        targetAssetLiquidity: getDefaultDoubleValue(json['targetAssetLiq']),
        volume: getDefaultDoubleValue(json['volume']),
        volumes: json['volumePeriods'],
        lockedLiquidity: getDefaultDoubleValue(json['lockedLiquidity']),
        tokenAssetId: getDefaultStringValue(json['tokenAssetId']),
        baseAssetId: getDefaultStringValue(json['baseAssetId']),
      );
}
