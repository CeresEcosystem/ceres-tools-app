abstract class FarmingRepository {
  Future getFarming();
  Future getFarmingTVL(String farming);
  Future getTokenInfos();
  Future getDemeterFarms();
  Future getDemeterPools();
}
