import 'package:ceres_tools_app/data/api/api.dart';
import 'package:dio/dio.dart';

class CurrencyDatasource {
  final RestClient client;

  CurrencyDatasource({required this.client});

  Future getCurrencyRates(String currency) async {
    try {
      return await client.getCurrencyRates(currency);
    } on DioException catch (_) {}
  }
}
