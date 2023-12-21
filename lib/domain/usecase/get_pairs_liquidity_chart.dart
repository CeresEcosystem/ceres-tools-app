import 'package:ceres_tools_app/domain/repository/pairs_liquidity_repository.dart';

class GetPairsLiquidityChart {
  final PairsLiquidityRepository repository;

  GetPairsLiquidityChart({required this.repository});

  Future execute(String baseToken, String token) async {
    return repository.getPairsLiquidityChart(baseToken, token);
  }
}
