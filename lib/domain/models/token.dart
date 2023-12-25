import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';

class Token {
  final String? shortName;
  final String? fullName;
  final String? priceString;
  final double? price;
  final String? assetId;
  bool isFavorite = false;
  String imageExtension = kImageExtension;

  Token({
    this.shortName,
    this.fullName,
    this.priceString,
    this.price,
    this.assetId,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        shortName: getDefaultStringValue(json['token']),
        fullName: getDefaultStringValue(json['fullName']),
        priceString: getDefaultStringValue(json['price']),
        price: getDefaultDoubleValue(json['price']),
        assetId: getDefaultStringValue(json['assetId']),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Token &&
          shortName == other.shortName &&
          fullName == other.fullName &&
          priceString == other.priceString &&
          price == other.price &&
          assetId == other.assetId &&
          isFavorite == other.isFavorite &&
          imageExtension == other.imageExtension;

  @override
  int get hashCode =>
      shortName.hashCode ^
      fullName.hashCode ^
      priceString.hashCode ^
      price.hashCode ^
      assetId.hashCode ^
      isFavorite.hashCode ^
      imageExtension.hashCode;
}
