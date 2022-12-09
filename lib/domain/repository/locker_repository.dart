abstract class LockerRepository {
  Future getLockedTokens(String token);
  Future getLockedPairs(String baseToken, String token);
}
