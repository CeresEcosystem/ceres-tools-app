import 'package:ceres_tools_app/core/utils/default_value.dart';

class Block {
  final int? blockNumber;
  final String? burnType;
  final double? xorSpent;
  final double? grossBurn;
  final double? remintedLp;
  final double? remintedParliament;
  final double? netBurn;
  final double? xorDedicatedForBuyBack;

  Block({
    this.blockNumber,
    this.burnType,
    this.xorSpent,
    this.grossBurn,
    this.remintedLp,
    this.remintedParliament,
    this.netBurn,
    this.xorDedicatedForBuyBack,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        blockNumber: getDefaultIntValue(json['blockNum']),
        burnType: getDefaultStringValue(json['burnType']),
        xorSpent: getDefaultDoubleValue(json['xorSpent']),
        grossBurn: getDefaultDoubleValue(json['grossBurn']),
        remintedLp: getDefaultDoubleValue(json['remintedLp']),
        remintedParliament: getDefaultDoubleValue(json['remintedParliament']),
        netBurn: getDefaultDoubleValue(json['netBurn']),
        xorDedicatedForBuyBack:
            getDefaultDoubleValue(json['xorDedicatedForBuyBack']),
      );

  @override
  String toString() {
    return burnType ?? '';
  }
}
