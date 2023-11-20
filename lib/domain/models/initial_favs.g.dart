// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_favs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: unused_element
InitialFavs _$InitialFavsFromJson(Map<String, dynamic> json) => InitialFavs(
      deviceId: json['deviceId'] as String?,
      tokens:
          (json['tokens'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$InitialFavsToJson(InitialFavs instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'tokens': instance.tokens,
    };
