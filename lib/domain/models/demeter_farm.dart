import 'package:ceres_locker_app/core/utils/default_value.dart';

class DemeterFarm {
  final String poolAsset;
  final String rewardAsset;
  final String baseAssetId;
  final String baseAsset;
  final int multiplier;
  final bool isCore;
  final double multiplierPercent;
  final bool isRemoved;
  final int depositFee;
  final String tvlPercent;

  DemeterFarm({
    required this.poolAsset,
    required this.rewardAsset,
    required this.baseAssetId,
    required this.baseAsset,
    required this.multiplier,
    required this.isCore,
    required this.multiplierPercent,
    required this.isRemoved,
    required this.depositFee,
    required this.tvlPercent,
  });

  factory DemeterFarm.fromJson(Map<String, dynamic> json) => DemeterFarm(
        poolAsset: getDefaultStringValue(json['poolAsset'])!,
        rewardAsset: getDefaultStringValue(json['rewardAsset'])!,
        baseAssetId: getDefaultStringValue(json['baseAssetId'])!,
        baseAsset: getDefaultStringValue(json['baseAsset'])!,
        multiplier: getDefaultIntValue(json['multiplier'])!,
        isCore: getDefaultBoolValue(json['isCore'])!,
        multiplierPercent: getDefaultDoubleValue(json['multiplierPercent'])!,
        isRemoved: getDefaultBoolValue(json['isRemoved'])!,
        depositFee: getDefaultIntValue(json['depositFee'])!,
        tvlPercent: getDefaultStringValue(json['tvlPercent'])!,
      );

  Map<String, dynamic> toJson() {
    return {
      'poolAsset': poolAsset,
      'rewardAsset': rewardAsset,
      'baseAssetId': baseAssetId,
      'baseAsset': baseAsset,
      'multiplier': multiplier,
      'isCore': isCore,
      'multiplierPercent': multiplierPercent,
      'isRemoved': isRemoved,
      'depositFee': depositFee,
      'tvlPercent': tvlPercent,
    };
  }
}
