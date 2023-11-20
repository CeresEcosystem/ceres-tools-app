import 'package:json_annotation/json_annotation.dart';

part 'favorite_token_json.g.dart';

@JsonSerializable()
class FavoriteTokenJSON {
  final String? deviceId;
  final String? token;

  FavoriteTokenJSON({
    this.deviceId,
    this.token,
  });

  Map<String, dynamic> toJson() => _$FavoriteTokenJSONToJson(this);
}
