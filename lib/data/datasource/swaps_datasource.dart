import 'package:ceres_tools_app/data/api/api.dart';
import 'package:ceres_tools_app/domain/models/swap_filter.dart';
import 'package:ceres_tools_app/domain/models/swap_tokens_json.dart';
import 'package:dio/dio.dart';

class SwapsDatasource {
  final RestClient client;

  SwapsDatasource({required this.client});

  Future getSwaps(
    SwapTokensJSON swapTokensJSON,
    int page,
    SwapFilter swapFilter,
  ) async {
    try {
      return await client.getSwaps(
        swapTokensJSON,
        page,
        swapFilter.dateFrom?.toIso8601String(),
        swapFilter.dateTo?.toIso8601String(),
        swapFilter.minAmount,
        swapFilter.maxAmount,
        swapFilter.assetIdAddress,
      );
    } on DioException catch (_) {}
  }

  Future getSwapsForAllTokens(
    int page,
    SwapFilter swapFilter,
  ) async {
    try {
      return await client.getSwapsForAllTokens(
        page,
        swapFilter.dateFrom?.toIso8601String(),
        swapFilter.dateTo?.toIso8601String(),
        swapFilter.minAmount,
        swapFilter.maxAmount,
        swapFilter.assetIdAddress,
      );
    } on DioException catch (_) {}
  }
}
