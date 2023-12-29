abstract class TokensRepository {
  Future getTokens();
  Future getTokenHolders(String assetId, int page);
  Future getXorHolders(int page);
}
