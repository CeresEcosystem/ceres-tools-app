import 'package:ceres_tools_app/domain/repository/pairs_liquidity_repository.dart';

class GetPairsLiquidityProviders {
  final PairsLiquidityRepository repository;

  GetPairsLiquidityProviders({required this.repository});

  Future execute(String baseAsset, String tokenAsset) async {
    return repository.getPairsLiquidityProviders(baseAsset, tokenAsset);
  }
}
