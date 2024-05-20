import 'package:ceres_tools_app/data/api/api.dart';
import 'package:ceres_tools_app/domain/models/burn_filter.dart';
import 'package:dio/dio.dart';

class BurningDatasource {
  final RestClient client;

  BurningDatasource({required this.client});

  Future getBurns(
    String token,
    int page,
    BurnFilter burnFilter,
  ) async {
    try {
      return await client.getBurns(
        token,
        page,
        burnFilter.dateFrom?.toIso8601String(),
        burnFilter.dateTo?.toIso8601String(),
        burnFilter.accountId,
      );
    } on DioException catch (_) {}
  }
}
