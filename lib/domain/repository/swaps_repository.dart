abstract class SwapsRepository {
  Future getSwaps(List<String> tokens, int page);
  Future getSwapsForAllTokens(int page);
}
