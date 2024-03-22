import 'package:ceres_tools_app/core/utils/default_value.dart';

class PairLiquidityProvider {
  final String address;
  final double liquidity;
  String? accountIdFormatted;
  String liquidityFormatted = '0';

  PairLiquidityProvider(
    this.address,
    this.liquidity,
  );

  factory PairLiquidityProvider.fromJson(Map<String, dynamic> json) =>
      PairLiquidityProvider(
        json['address'],
        getDefaultDoubleValueNotNullable(json['liquidity']),
      );
}
