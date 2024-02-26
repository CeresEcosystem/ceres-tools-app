import 'package:ceres_tools_app/data/api/api.dart';
import 'package:ceres_tools_app/domain/models/kensetsu_filter.dart';
import 'package:dio/dio.dart';

class KensetsuDatasource {
  final RestClient client;

  KensetsuDatasource({required this.client});

  Future getKensetsuBurns(
    int page,
    KensetsuFilter kensetsuFilter,
  ) async {
    try {
      return await client.getKensetsuBurns(
        page,
        kensetsuFilter.dateFrom?.toIso8601String(),
        kensetsuFilter.dateTo?.toIso8601String(),
        kensetsuFilter.accountId,
      );
    } on DioException catch (_) {}
  }
}
