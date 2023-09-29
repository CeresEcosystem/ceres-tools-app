import 'package:ceres_locker_app/data/api/api.dart';
import 'package:dio/dio.dart';

class SwapsDatasource {
  final RestClient client;

  SwapsDatasource({required this.client});

  Future getSwaps(String address, int page) async {
    try {
      return await client.getSwaps(address, page);
    } on DioException catch (_) {}
  }
}
