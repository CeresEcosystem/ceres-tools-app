import 'package:ceres_tools_app/data/api/api.dart';
import 'package:ceres_tools_app/domain/models/xor_holder_json.dart';
import 'package:dio/dio.dart';

class TokensDatasource {
  final RestClient client;

  TokensDatasource({required this.client});

  Future getTokens() async {
    try {
      return await client.getTokens();
    } on DioException catch (_) {}
  }

  Future getTokenHolders(String assetId, int page) async {
    try {
      return await client.getTokenHolders(assetId, page);
    } on DioException catch (_) {}
  }

  Future getXorHolders(int page) async {
    try {
      return await client.getXorHolders(XorHolderJSON(page: page - 1));
    } on DioException catch (_) {}
  }
}
