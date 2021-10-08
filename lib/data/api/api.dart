import 'package:ceres_locker_app/data/api/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi(baseUrl: ApiConstants.BASE_URL)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET(ApiConstants.TOKENS_PERMALINK)
  Future getTokens();

  @GET(ApiConstants.PAIRS_PERMALINK)
  Future getPairs();

  @GET(ApiConstants.FARMING_PERMALINK)
  Future getFarming();

  @GET(ApiConstants.TRACKER_PERMALINK)
  Future getTracker();
}