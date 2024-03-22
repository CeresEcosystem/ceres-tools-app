abstract class PairsLiquidityRepository {
  Future getPairsLiquidity(String baseAsset, String tokenAsset, int page);
  Future getPairsLiquidityProviders(String baseAsset, String tokenAsset);
  Future getPairsLiquidityChart(String baseToken, String token);
}
