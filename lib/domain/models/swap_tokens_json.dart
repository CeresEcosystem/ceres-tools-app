import 'package:json_annotation/json_annotation.dart';

part 'swap_tokens_json.g.dart';

@JsonSerializable()
class SwapTokensJSON {
  final List<String> tokens;

  SwapTokensJSON(
    this.tokens,
  );

  Map<String, dynamic> toJson() => _$SwapTokensJSONToJson(this);
}
