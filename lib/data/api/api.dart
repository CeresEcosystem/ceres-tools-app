import 'package:ceres_locker_app/data/api/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.TOKENS_PERMALINK}')
  Future getTokens();

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.PAIRS_PERMALINK}')
  Future getPairs();

  @GET('${ApiConstants.DEMETER_URL}${ApiConstants.TOKEN_INFOS_PERMALINK}')
  Future getTokenInfos();

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.FARMING_PERMALINK}')
  Future getFarming();

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.TRACKER_PERMALINK}')
  Future getTracker(@Path("token") String token);

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.BANNERS_PERMALINK}')
  Future getBanners();

  @GET('${ApiConstants.LOCK_URL}${ApiConstants.LOCK_TOKEN_PERMALINK}')
  Future getLockedTokens(@Path("token") String token);

  @GET('${ApiConstants.LOCK_URL}${ApiConstants.LOCK_PAIR_PERMALINK}')
  Future getLockedPairs(
      @Path("baseAsset") String baseAsset, @Path("token") String token);

  @GET('${ApiConstants.DEMETER_URL}${ApiConstants.DEMETER_TVL_PERMALINK}')
  Future getDemeterFarmingTVL();

  @GET(ApiConstants.HERMES_TVL_URL)
  Future getHermesFarmingTVL();

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.PSWAP_TVL_PERMALINK}')
  Future getPSWAPFarmingTVL();

  @GET('${ApiConstants.DEMETER_URL}${ApiConstants.DEMETER_FARMS_PERMALINK}')
  Future getDemeterFarms();

  @GET('${ApiConstants.DEMETER_URL}${ApiConstants.DEMETER_POOLS_PERMALINK}')
  Future getDemeterPools();

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.PORTFOLIO_PERMALINK}')
  Future getPortfolioItems(@Path("address") String address);
}
