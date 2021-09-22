import 'package:ceres_locker_app/core/utils/default_value.dart';

class Token {
  final int? id;
  final String? shortName;
  final String? fullName;
  final double? price;
  final String? assetId;
  final int? priceOrder;

  Token({
    this.id,
    this.shortName,
    this.fullName,
    this.price,
    this.assetId,
    this.priceOrder,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        id: getDefaultIntValue(json['id']),
        shortName: getDefaultStringValue(json['token']),
        fullName: getDefaultStringValue(json['full_name']),
        price: getDefaultDoubleValue(json['price']),
        assetId: getDefaultStringValue(json['asset_id']),
        priceOrder: getDefaultIntValue(json['price_order']),
      );
}
