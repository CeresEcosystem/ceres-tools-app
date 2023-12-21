import 'package:ceres_tools_app/data/api/api.dart';
import 'package:dio/dio.dart';

class PairsLiquidityDatasource {
  final RestClient client;

  PairsLiquidityDatasource({required this.client});

  Future getPairsLiquidity(
      String baseAsset, String tokenAsset, int page) async {
    try {
      return await client.getPairsLiquidity(baseAsset, tokenAsset, page);
    } on DioException catch (_) {}
  }

  Future getPairsLiquidityChart(String baseToken, String token) async {
    try {
      return await client.getPairsLiquidityChart(baseToken, token);
    } on DioException catch (_) {}
  }
}
