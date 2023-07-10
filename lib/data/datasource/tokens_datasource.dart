import 'package:ceres_locker_app/data/api/api.dart';
import 'package:dio/dio.dart';

class TokensDatasource {
  final RestClient client;

  TokensDatasource({required this.client});

  Future getTokens() async {
    try {
      return await client.getTokens();
    } on DioException catch (_) {}
  }
}
