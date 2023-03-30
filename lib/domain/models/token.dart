import 'package:ceres_locker_app/core/utils/default_value.dart';

class Token {
  final String? shortName;
  final String? fullName;
  final double? price;
  final String? assetId;
  bool isFavorite = false;

  Token({
    this.shortName,
    this.fullName,
    this.price,
    this.assetId,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        shortName: getDefaultStringValue(json['token']),
        fullName: getDefaultStringValue(json['fullName']),
        price: getDefaultDoubleValue(json['price']),
        assetId: getDefaultStringValue(json['assetId']),
      );
}
