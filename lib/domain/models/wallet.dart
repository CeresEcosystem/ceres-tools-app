import 'package:ceres_locker_app/core/utils/address_format.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';

class Wallet {
  final String name;
  final String address;

  Wallet(
    this.name,
    this.address,
  );

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        getDefaultStringValue(json['name'])!,
        getDefaultStringValue(json['address'])!,
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
    };
  }

  @override
  String toString() {
    return '$name (${formatAddress(address)})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Wallet && other.name == name && other.address == address;
  }

  @override
  int get hashCode => name.hashCode ^ address.hashCode;
}
