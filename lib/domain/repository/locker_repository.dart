abstract class LockerRepository {
  Future getLockedTokens(String token);
  Future getLockedPairs(String token);
}
