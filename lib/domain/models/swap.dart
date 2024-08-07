import 'package:ceres_tools_app/core/utils/default_value.dart';

class Swap {
  final int id;
  String swappedAt;
  final String accountId;
  final String inputAssetId;
  final String outputAssetId;
  double assetInputAmount;
  double assetOutputAmount;
  String? inputAsset;
  String? outputAsset;
  String? type;
  String? formattedAccountId;

  Swap(
    this.id,
    this.swappedAt,
    this.accountId,
    this.inputAssetId,
    this.outputAssetId,
    this.assetInputAmount,
    this.assetOutputAmount,
  );

  factory Swap.fromJson(Map<String, dynamic> json) => Swap(
        json['id'],
        json['swappedAt'],
        json['accountId'],
        json['inputAssetId'],
        json['outputAssetId'],
        getDefaultDoubleValueNotNullable(json['assetInputAmount']),
        getDefaultDoubleValueNotNullable(json['assetOutputAmount']),
      );
}
