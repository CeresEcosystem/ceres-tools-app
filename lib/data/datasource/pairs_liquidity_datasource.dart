import 'package:ceres_locker_app/data/api/api.dart';
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
}
