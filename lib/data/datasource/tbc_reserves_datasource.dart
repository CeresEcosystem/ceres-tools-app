import 'package:ceres_tools_app/data/api/api.dart';
import 'package:dio/dio.dart';

class TBCReservesDatasource {
  final RestClient client;

  TBCReservesDatasource({required this.client});

  Future getTBCReserves() async {
    try {
      return await client.getTBCReserves();
    } on DioException catch (_) {}
  }
}
