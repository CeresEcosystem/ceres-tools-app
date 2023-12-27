abstract class TokensRepository {
  Future getTokens();
  Future getTokenHolders(String assetId, int page);
}
