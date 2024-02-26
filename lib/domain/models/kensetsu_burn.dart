import 'package:ceres_tools_app/core/utils/default_value.dart';

class KensetsuBurn {
  final String accountId;
  final String assetId;
  final double amountBurned;
  String createdAt;
  String? formattedAccountId;
  double? kenAllocated;

  KensetsuBurn(
    this.accountId,
    this.assetId,
    this.amountBurned,
    this.createdAt,
  );

  factory KensetsuBurn.fromJson(Map<String, dynamic> json) => KensetsuBurn(
        json['accountId'],
        json['assetId'],
        getDefaultDoubleValueNotNullable(json['amountBurned']),
        json['createdAt'],
      );
}
