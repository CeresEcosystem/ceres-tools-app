import 'package:ceres_tools_app/data/datasource/pairs_liquidity_datasource.dart';
import 'package:ceres_tools_app/domain/repository/pairs_liquidity_repository.dart';

class PairsLiquidityRepositoryImpl implements PairsLiquidityRepository {
  final PairsLiquidityDatasource datasource;

  PairsLiquidityRepositoryImpl({required this.datasource});

  @override
  Future getPairsLiquidity(
      String baseAsset, String tokenAsset, int page) async {
    try {
      return await datasource.getPairsLiquidity(baseAsset, tokenAsset, page);
    } on Exception catch (_) {}
  }

  @override
  Future getPairsLiquidityProviders(String baseAsset, String tokenAsset) async {
    try {
      return await datasource.getPairsLiquidityProviders(baseAsset, tokenAsset);
    } on Exception catch (_) {}
  }

  @override
  Future getPairsLiquidityChart(String baseToken, String token) async {
    try {
      return await datasource.getPairsLiquidityChart(baseToken, token);
    } on Exception catch (_) {}
  }
}
