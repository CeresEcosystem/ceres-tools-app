import 'package:ceres_tools_app/core/utils/default_value.dart';

class DemeterPool {
  final String poolAsset;
  final String rewardAsset;
  final int multiplier;
  final bool isCore;
  final double multiplierPercent;
  final bool isRemoved;
  final int depositFee;
  final double totalStaked;

  DemeterPool({
    required this.poolAsset,
    required this.rewardAsset,
    required this.multiplier,
    required this.isCore,
    required this.multiplierPercent,
    required this.isRemoved,
    required this.depositFee,
    required this.totalStaked,
  });

  factory DemeterPool.fromJson(Map<String, dynamic> json) => DemeterPool(
        poolAsset: getDefaultStringValue(json['poolAsset'])!,
        rewardAsset: getDefaultStringValue(json['rewardAsset'])!,
        multiplier: getDefaultIntValue(json['multiplier'])!,
        isCore: getDefaultBoolValue(json['isCore'])!,
        multiplierPercent: getDefaultDoubleValue(json['multiplierPercent'])!,
        isRemoved: getDefaultBoolValue(json['isRemoved'])!,
        depositFee: getDefaultIntValue(json['depositFee'])!,
        totalStaked: getDefaultDoubleValue(json['totalStaked'])!,
      );

  Map<String, dynamic> toJson() {
    return {
      'poolAsset': poolAsset,
      'rewardAsset': rewardAsset,
      'multiplier': multiplier,
      'isCore': isCore,
      'multiplierPercent': multiplierPercent,
      'isRemoved': isRemoved,
      'depositFee': depositFee,
      'totalStaked': totalStaked,
    };
  }
}
