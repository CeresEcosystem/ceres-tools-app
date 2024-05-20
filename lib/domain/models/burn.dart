import 'package:ceres_tools_app/core/utils/default_value.dart';

class Burn {
  final String accountId;
  final String assetId;
  final double amountBurned;
  String createdAt;
  String? formattedAccountId;
  double? tokenAllocated;

  Burn(
    this.accountId,
    this.assetId,
    this.amountBurned,
    this.createdAt,
  );

  factory Burn.fromJson(Map<String, dynamic> json) => Burn(
        json['accountId'],
        json['assetId'],
        getDefaultDoubleValueNotNullable(json['amountBurned']),
        json['createdAt'],
      );
}
