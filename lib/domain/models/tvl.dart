import 'package:ceres_locker_app/core/utils/default_value.dart';

class TVL {
  final double? maxSupply;
  final double? currentSupply;
  final double? tvl;
  final double? burned;

  TVL({
    this.maxSupply,
    this.currentSupply,
    this.tvl,
    this.burned,
  });

  factory TVL.fromJson(Map<String, dynamic> json) => TVL(
        maxSupply: getDefaultDoubleValue(json['maxSupply']),
        currentSupply: getDefaultDoubleValue(json['currentSupply']),
        tvl: getDefaultDoubleValue(json['tvl']),
        burned: getDefaultDoubleValue(json['burned']),
      );
}
