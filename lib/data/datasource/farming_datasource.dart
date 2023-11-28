import 'package:ceres_tools_app/data/api/api.dart';
import 'package:dio/dio.dart';

class FarmingDatasource {
  final RestClient client;

  FarmingDatasource({required this.client});

  Future getFarming() async {
    try {
      return await client.getFarming();
    } on DioException catch (_) {}
  }

  Future getFarmingTVL(String farming) async {
    try {
      switch (farming) {
        case 'Demeter':
          return await client.getDemeterFarmingTVL();
        case 'Hermes':
          return await client.getHermesFarmingTVL();
        case 'PSWAP':
          return await client.getPSWAPFarmingTVL();
      }
    } on DioException catch (_) {}
  }

  Future getTokenInfos() async {
    try {
      return await client.getTokenInfos();
    } on DioException catch (_) {}
  }

  Future getDemeterFarms() async {
    try {
      return await client.getDemeterFarms();
    } on DioException catch (_) {}
  }

  Future getDemeterPools() async {
    try {
      return await client.getDemeterPools();
    } on DioException catch (_) {}
  }
}
