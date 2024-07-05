import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/transfer_direction.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';

class Transfer {
  final String? sender;
  final double? amount;
  final String? asset;
  final String? receiver;
  final String? type;
  final String? direction;
  final String transferredAt;
  String? tokenFormatted;
  String tokenImageExtension = kImageExtension;
  String? transferredAtFormatted;

  Transfer(
    this.sender,
    this.amount,
    this.asset,
    this.receiver,
    this.type,
    this.direction,
    this.transferredAt,
  );

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
        getDefaultStringValue(json['sender']),
        getDefaultDoubleValue(json['amount']),
        getDefaultStringValue(json['asset']),
        getDefaultStringValue(json['receiver']),
        getDefaultStringValue(json['type']),
        getDefaultStringValue(json['direction']),
        json['transferredAt'],
      );

  String get directionFormatted {
    TransferDirection? td = direction == 'burned'
        ? TransferDirection.BURNED
        : direction == 'minted'
            ? TransferDirection.MINTED
            : null;

    switch (type) {
      case 'Sora':
        return 'SORA -> SORA';
      case 'ETH':
        return td == TransferDirection.BURNED ? 'SORA -> ETH' : 'ETH -> SORA';
      case 'Polkadot':
        if (asset == kXorAddress) {
          return td == TransferDirection.BURNED
              ? 'SORA -> SORA Polkadot'
              : 'SORA Polkadot -> SORA';
        } else if (asset == kDotAddress) {
          return td == TransferDirection.BURNED
              ? 'SORA -> Polkadot'
              : 'Polkadot -> SORA';
        } else if (asset == kAstarAddress) {
          return td == TransferDirection.BURNED
              ? 'SORA -> Astar Polkadot'
              : 'Astar Polkadot -> SORA';
        } else if (asset == kAcalaAddress) {
          return td == TransferDirection.BURNED
              ? 'SORA -> Acala Polkadot'
              : 'Acala Polkadot -> SORA';
        }
        return '';
      case 'Kusama':
        if (asset == kXorAddress) {
          return td == TransferDirection.BURNED
              ? 'SORA -> SORA Kusama'
              : 'SORA Kusama -> SORA';
        } else if (asset == kKSMAddress) {
          return td == TransferDirection.BURNED
              ? 'SORA -> Kusama'
              : 'Kusama -> SORA';
        }
        return '';
      case 'Liberland':
        return td == TransferDirection.BURNED
            ? 'SORA -> Liberland'
            : 'Liberland -> SORA';
      default:
        return '';
    }
  }
}
