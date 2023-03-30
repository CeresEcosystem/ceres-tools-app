import 'package:ceres_locker_app/core/utils/default_value.dart';

class Block {
  final int? blockNumber;
  final double? xorSpent;
  final double? pswapGrossBurn;
  final double? pswapRemintedLP;
  final double? pswapRemintedParliament;
  final double? pswapNetBurn;

  Block({
    this.blockNumber,
    this.xorSpent,
    this.pswapGrossBurn,
    this.pswapRemintedLP,
    this.pswapRemintedParliament,
    this.pswapNetBurn,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        blockNumber: getDefaultIntValue(json['blockNum']),
        xorSpent: getDefaultDoubleValue(json['xorSpent']),
        pswapGrossBurn: getDefaultDoubleValue(json['pswapGrossBurn']),
        pswapRemintedLP: getDefaultDoubleValue(json['pswapRemintedLp']),
        pswapRemintedParliament:
            getDefaultDoubleValue(json['pswapRemintedParliament']),
        pswapNetBurn: getDefaultDoubleValue(json['pswapNetBurn']),
      );
}
