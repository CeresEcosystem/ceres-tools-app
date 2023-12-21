abstract class PairsLiquidityRepository {
  Future getPairsLiquidity(String baseAsset, String tokenAsset, int page);
  Future getPairsLiquidityChart(String baseToken, String token);
}
