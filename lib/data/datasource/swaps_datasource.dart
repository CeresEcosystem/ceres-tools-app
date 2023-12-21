import 'package:ceres_tools_app/data/api/api.dart';
import 'package:dio/dio.dart';

class SwapsDatasource {
  final RestClient client;

  SwapsDatasource({required this.client});

  Future getSwaps(List<String> tokens, int page) async {
    try {
      return await client.getSwaps(tokens, page);
    } on DioException catch (_) {}
  }

  Future getSwapsForAllTokens(int page) async {
    try {
      return await client.getSwapsForAllTokens(page);
    } on DioException catch (_) {}
  }
}
