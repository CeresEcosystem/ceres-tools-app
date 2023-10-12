import 'package:ceres_locker_app/core/utils/address_format.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';

class Wallet {
  final String name;
  final String address;
  bool temporaryAddress = false;

  Wallet(
    this.name,
    this.address,
    this.temporaryAddress,
  );

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
      getDefaultStringValue(json['name'])!,
      getDefaultStringValue(json['address'])!,
      false);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
    };
  }

  @override
  String toString() {
    return name.isNotEmpty
        ? '$name (${formatAddress(address)})'
        : formatAddress(address, 9);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Wallet && other.address == address;
  }

  @override
  int get hashCode => address.hashCode;
}
