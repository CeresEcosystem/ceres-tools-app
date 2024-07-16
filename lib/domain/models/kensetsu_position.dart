import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/domain/models/token.dart';

class KensetsuPosition {
  final String collateralAssetId;
  final String stablecoinAssetId;
  final double interest;
  final double collateralAmount;
  final double debt;
  Token? collateralToken;
  Token? stablecoinToken;

  KensetsuPosition(
    this.collateralAssetId,
    this.stablecoinAssetId,
    this.interest,
    this.collateralAmount,
    this.debt,
  );

  factory KensetsuPosition.fromJson(Map<String, dynamic> json) =>
      KensetsuPosition(
        json['collateralAssetId'],
        json['stablecoinAssetId'],
        getDefaultDoubleValueNotNullable(json['interest']),
        getDefaultDoubleValueNotNullable(json['collateralAmount']),
        getDefaultDoubleValueNotNullable(json['debt']),
      );
}
