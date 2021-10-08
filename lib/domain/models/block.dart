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
        blockNumber: getDefaultIntValue(json['block_num']),
        xorSpent: getDefaultDoubleValue(json['xor_spent']),
        pswapGrossBurn: getDefaultDoubleValue(json['pswap_gross_burn']),
        pswapRemintedLP: getDefaultDoubleValue(json['pswap_reminted_lp']),
        pswapRemintedParliament: getDefaultDoubleValue(json['pswap_reminted_parliament']),
        pswapNetBurn: getDefaultDoubleValue(json['pswap_net_burn']),
      );
}
