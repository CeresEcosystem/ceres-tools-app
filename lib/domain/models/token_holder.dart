import 'package:ceres_tools_app/core/utils/default_value.dart';

class TokenHolder {
  final String holder;
  final double balance;
  String? accountIdFormatted;
  String balanceFormatted = '0';

  TokenHolder(
    this.holder,
    this.balance,
  );

  factory TokenHolder.fromJson(Map<String, dynamic> json) => TokenHolder(
        json['holder'],
        getDefaultDoubleValueNotNullable(json['balance']),
      );
}
