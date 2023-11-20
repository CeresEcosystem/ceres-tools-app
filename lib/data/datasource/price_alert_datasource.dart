import 'package:ceres_locker_app/data/api/api.dart';
import 'package:ceres_locker_app/domain/models/favorite_token_json.dart';
import 'package:ceres_locker_app/domain/models/initial_favs.dart';
import 'package:dio/dio.dart';

class PriceAlertDatasource {
  final RestClient client;

  PriceAlertDatasource({required this.client});

  Future postInitialFavs(InitialFavs initialFavs) async {
    try {
      return await client.postInitialFavs(initialFavs);
    } on DioException catch (_) {}
  }

  Future addTokenToFavorites(FavoriteTokenJSON favoriteToken) async {
    try {
      return await client.addTokenToFavorites(favoriteToken);
    } on DioException catch (_) {}
  }

  Future removeTokenFromFavorites(String deviceId, String token) async {
    try {
      return await client.removeTokenFromFavorites(deviceId, token);
    } on DioException catch (_) {}
  }
}
