import 'package:ceres_tools_app/data/api/api.dart';
import 'package:dio/dio.dart';

class ApolloDatasource {
  final RestClient client;

  ApolloDatasource({required this.client});

  Future getApolloDashboard(String address) async {
    try {
      return await client.getApolloDashboard(address);
    } on DioException catch (_) {}
  }
}
