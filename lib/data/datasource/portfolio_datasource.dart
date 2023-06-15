import 'package:ceres_locker_app/data/api/api.dart';
import 'package:dio/dio.dart';

class PortfolioDatasource {
  final RestClient client;

  PortfolioDatasource({required this.client});

  Future getPortfolioItems(String address) async {
    try {
      return await client.getPortfolioItems(address);
    } on DioError catch (_) {}
  }
}
