import 'package:ceres_tools_app/data/api/api_constants.dart';
import 'package:ceres_tools_app/domain/models/favorite_token_json.dart';
import 'package:ceres_tools_app/domain/models/initial_favs.dart';
import 'package:ceres_tools_app/domain/models/swap_tokens_json.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.TOKENS_PERMALINK}')
  Future getTokens();

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.TOKEN_HOLDERS_PERMALINK}')
  Future getTokenHolders(
      @Query('assetId') String assetId, @Query('page') int page);

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.PAIRS_PERMALINK}')
  Future getPairs();

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.PAIRS_LIQUIDITY}')
  Future getPairsLiquidity(@Path("baseAsset") String baseAsset,
      @Path("tokenAsset") String tokenAsset, @Query("page") int page);

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.PAIRS_LIQUIDITY_CHART}')
  Future getPairsLiquidityChart(
      @Path("baseToken") String baseToken, @Path("token") String token);

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
  Future getPortfolioItems(
      @Path("address") String address, @Query("page") int page);

  @POST('${ApiConstants.NEW_BASE_URL}${ApiConstants.SWAPS_PERMALINK}')
  Future getSwaps(
    @Body() SwapTokensJSON swapTokensJSON,
    @Query("page") int page,
    @Query('dateFrom') String? dateFrom,
    @Query('dateTo') String? dateTo,
    @Query('minAmount') String? minAmount,
    @Query('maxAmount') String? maxAmount,
    @Query('assetId') String? assetId,
  );

  @GET(
      '${ApiConstants.NEW_BASE_URL}${ApiConstants.SWAPS_FOR_ALL_TOKENS_PERMALINK}')
  Future getSwapsForAllTokens(
    @Query("page") int page,
    @Query('dateFrom') String? dateFrom,
    @Query('dateTo') String? dateTo,
    @Query('minAmount') String? minAmount,
    @Query('maxAmount') String? maxAmount,
    @Query('assetId') String? assetId,
  );

  @POST('${ApiConstants.NEW_BASE_URL}${ApiConstants.INITIAL_FAVS_PERMALINK}')
  Future postInitialFavs(@Body() InitialFavs initialFavs);

  @POST(
      '${ApiConstants.NEW_BASE_URL}${ApiConstants.ADD_TOKEN_TO_FAVORITES_PERMALINK}')
  Future addTokenToFavorites(@Body() FavoriteTokenJSON favoriteToken);

  @DELETE(
      '${ApiConstants.NEW_BASE_URL}${ApiConstants.REMOVE_TOKEN_FROM_FAVORITES_PERMALINK}')
  Future removeTokenFromFavorites(
      @Path() String deviceId, @Path() String token);

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.TBC_RESERVES_PERMALINK}')
  Future getTBCReserves();
}
