import 'package:ceres_tools_app/core/utils/default_value.dart';

class SwapsStats {
  int buys;
  double tokensBought;
  int sells;
  double tokensSold;

  SwapsStats(
    this.buys,
    this.tokensBought,
    this.sells,
    this.tokensSold,
  );

  factory SwapsStats.fromJson(Map<String, dynamic> json) => SwapsStats(
        json['buys'],
        getDefaultDoubleValueNotNullable(json['tokensBought']),
        json['sells'],
        getDefaultDoubleValueNotNullable(json['tokensSold']),
      );
}
