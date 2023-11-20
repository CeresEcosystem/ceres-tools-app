import 'package:json_annotation/json_annotation.dart';

part 'initial_favs.g.dart';

@JsonSerializable()
class InitialFavs {
  final String? deviceId;
  final List<String>? tokens;

  InitialFavs({
    this.deviceId,
    this.tokens,
  });

  Map<String, dynamic> toJson() => _$InitialFavsToJson(this);
}
