import 'package:ceres_tools_app/data/api/api.dart';
import 'package:dio/dio.dart';

class PortfolioDatasource {
  final RestClient client;

  PortfolioDatasource({required this.client});

  Future getPortfolioItems(String address, int page) async {
    try {
      return await client.getPortfolioItems(address, page);
    } on DioException catch (_) {}
  }
}
