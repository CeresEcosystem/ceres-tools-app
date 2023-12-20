import 'package:ceres_tools_app/core/utils/default_value.dart';

class TBCReserve {
  final String tokenName;
  final String tokenSymbol;
  final double balance;
  final double value;
  final String updatedAt;

  TBCReserve(
    this.tokenName,
    this.tokenSymbol,
    this.balance,
    this.value,
    this.updatedAt,
  );

  factory TBCReserve.fromJson(Map<String, dynamic> json) => TBCReserve(
        json['tokenName'],
        json['tokenSymbol'],
        getDefaultDoubleValueNotNullable(json['balance']),
        getDefaultDoubleValueNotNullable(json['value']),
        json['updatedAt'],
      );

  Map<String, dynamic> toJson() {
    return {
      'tokenName': tokenName,
      'tokenSymbol': tokenSymbol,
      'balance': balance,
      'value': value,
      'updatedAt': updatedAt,
    };
  }
}
