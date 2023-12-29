// ignore_for_file: non_constant_identifier_names

import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'xor_holder_json.g.dart';

@JsonSerializable()
class XorHolderJSON {
  String order;
  String order_field;
  int page;
  int row;

  XorHolderJSON({
    this.order = 'desc',
    required this.page,
    this.order_field = 'balance',
    this.row = kPageSize,
  });

  Map<String, dynamic> toJson() => _$XorHolderJSONToJson(this);
}
