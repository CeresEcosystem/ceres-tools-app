import 'package:ceres_locker_app/data/api/api.dart';
import 'package:dio/dio.dart';

class PairsDatasource {
  final RestClient client;

  PairsDatasource({required this.client});

  Future getPairs() async {
    try {
      return await client.getPairs();
    } on DioException catch (_) {}
  }
}
