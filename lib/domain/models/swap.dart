import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';

class Swap {
  String swappedAt;
  final String accountId;
  final String inputAssetId;
  final String outputAssetId;
  final double assetInputAmount;
  final double assetOutputAmount;
  String? inputAsset;
  String? outputAsset;
  String? type;
  String? formattedAccountId;
  String inputImageExtension = kImageExtension;
  String outputImageExtension = kImageExtension;

  Swap(
    this.swappedAt,
    this.accountId,
    this.inputAssetId,
    this.outputAssetId,
    this.assetInputAmount,
    this.assetOutputAmount,
  );

  factory Swap.fromJson(Map<String, dynamic> json) => Swap(
        json['swappedAt'],
        json['accountId'],
        json['inputAssetId'],
        json['outputAssetId'],
        getDefaultDoubleValueNotNullable(json['assetInputAmount']),
        getDefaultDoubleValueNotNullable(json['assetOutputAmount']),
      );
}
