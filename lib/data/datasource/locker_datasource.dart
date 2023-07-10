import 'package:ceres_locker_app/data/api/api.dart';
import 'package:dio/dio.dart';

class LockerDatasource {
  final RestClient client;

  LockerDatasource({required this.client});

  Future getLockedTokens(String token) async {
    try {
      return await client.getLockedTokens(token);
    } on DioException catch (_) {}
  }

  Future getLockedPairs(String baseToken, String token) async {
    try {
      return await client.getLockedPairs(baseToken, token);
    } on DioException catch (_) {}
  }
}
