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

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.FARMING_PERMALINK}')
  Future getFarming();

  @GET('${ApiConstants.NEW_BASE_URL}${ApiConstants.TRACKER_PERMALINK}')
  Future getTracker();

  @GET('${ApiConstants.OLD_BASE_URL}${ApiConstants.BANNERS_PERMALINK}')
  Future getBanners();

  @GET('${ApiConstants.OLD_BASE_URL}${ApiConstants.LOCK_TOKEN_PERMALINK}')
  Future getLockedTokens(@Path("token") String token);

  @GET('${ApiConstants.OLD_BASE_URL}${ApiConstants.LOCK_PAIR_PERMALINK}')
  Future getLockedPairs(
      @Path("baseAsset") String baseAsset, @Path("token") String token);
}
