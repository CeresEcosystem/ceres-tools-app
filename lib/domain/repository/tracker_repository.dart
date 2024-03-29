abstract class TrackerRepository {
  Future getTracker(String token);
  Future getTrackerSupply(String token);
  Future getTrackerBlocks(String token, String type, int page);
}
