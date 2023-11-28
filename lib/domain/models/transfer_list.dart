import 'package:ceres_tools_app/domain/models/transfer.dart';

class TransferList {
  List<Transfer> _transfers = [];

  TransferList(this._transfers);

  List<Transfer> get transfers => _transfers;

  factory TransferList.fromJson(List<dynamic> json) {
    return TransferList(
      json.map((e) => Transfer.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
