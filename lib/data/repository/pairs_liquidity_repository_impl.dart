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
}
