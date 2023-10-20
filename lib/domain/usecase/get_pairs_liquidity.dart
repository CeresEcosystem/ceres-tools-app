import 'package:ceres_locker_app/domain/repository/pairs_liquidity_repository.dart';

class GetPairsLiquidity {
  final PairsLiquidityRepository repository;

  GetPairsLiquidity({required this.repository});

  Future execute(String baseAsset, String tokenAsset, int page) async {
    return repository.getPairsLiquidity(baseAsset, tokenAsset, page);
  }
}
