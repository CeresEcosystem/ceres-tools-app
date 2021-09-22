import 'package:ceres_locker_app/core/utils/default_value.dart';

class Farm {
  final String? apr;
  final String? rewards;
  final String? aprDouble;
  final String? rewardsDouble;

  Farm({
    this.apr,
    this.rewards,
    this.aprDouble,
    this.rewardsDouble,
  });

  factory Farm.fromJson(Map<String, dynamic> json) => Farm(
        apr: getDefaultStringValue(json['apr']),
        rewards: getDefaultStringValue(json['rewards']),
        aprDouble: getDefaultStringValue(json['aprDouble']),
        rewardsDouble: getDefaultStringValue(json['rewardsDouble']),
      );
}
