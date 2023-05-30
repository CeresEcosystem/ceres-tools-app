import 'package:ceres_locker_app/core/network/network_info.dart';
import 'package:ceres_locker_app/data/api/api.dart';
import 'package:ceres_locker_app/data/datasource/banner_datasource.dart';
import 'package:ceres_locker_app/data/datasource/farming_datasource.dart';
import 'package:ceres_locker_app/data/datasource/locker_datasource.dart';
import 'package:ceres_locker_app/data/datasource/pairs_datasource.dart';
import 'package:ceres_locker_app/data/datasource/tokens_datasource.dart';
import 'package:ceres_locker_app/data/datasource/tracker_datasource.dart';
import 'package:ceres_locker_app/data/repository/farming_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/locker_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/pairs_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/tokens_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/tracker_repository_impl.dart';
import 'package:ceres_locker_app/domain/repository/farming_repository.dart';
import 'package:ceres_locker_app/domain/repository/locker_repository.dart';
import 'package:ceres_locker_app/domain/repository/pairs_repository.dart';
import 'package:ceres_locker_app/domain/repository/tokens_repository.dart';
import 'package:ceres_locker_app/domain/repository/tracker_repository.dart';
import 'package:ceres_locker_app/domain/usecase/get_demeter_farms.dart';
import 'package:ceres_locker_app/domain/usecase/get_demeter_pools.dart';
import 'package:ceres_locker_app/domain/usecase/get_farming.dart';
import 'package:ceres_locker_app/domain/usecase/get_farming_tvl.dart';
import 'package:ceres_locker_app/domain/usecase/get_locked_pairs.dart';
import 'package:ceres_locker_app/domain/usecase/get_locked_tokens.dart';
import 'package:ceres_locker_app/domain/usecase/get_pairs.dart';
import 'package:ceres_locker_app/domain/usecase/get_token_infos.dart';
import 'package:ceres_locker_app/domain/usecase/get_tokens.dart';
import 'package:ceres_locker_app/domain/usecase/get_tracker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:kiwi/kiwi.dart';

part 'injector.g.dart';

abstract class Injector {
  static KiwiContainer? container;

  static void setup() {
    container = KiwiContainer();
    _$Injector()._configure();
  }

  static final resolve = container?.resolve;

  void _configure() {
    _configureCore();
    _configureFeatureModule();
    _configureTokensModuleFactories();
  }

  @Register.singleton(Connectivity)
  @Register.singleton(NetworkInfoI, from: NetworkInfo)
  void _configureCore();

  void _configureFeatureModule() {
    _configureRestClient();
  }

  void _configureRestClient() {
    container?.registerInstance(
        RestClient(Dio(BaseOptions(contentType: 'application/json'))));
  }

  @Register.factory(TokensDatasource)
  @Register.factory(PairsDatasource)
  @Register.factory(FarmingDatasource)
  @Register.factory(TrackerDatasource)
  @Register.factory(BannerDatasource)
  @Register.factory(LockerDatasource)
  @Register.factory(GetTokens)
  @Register.factory(GetPairs)
  @Register.factory(GetFarming)
  @Register.factory(GetFarmingTVL)
  @Register.factory(GetTokenInfos)
  @Register.factory(GetDemeterFarms)
  @Register.factory(GetDemeterPools)
  @Register.factory(GetTracker)
  @Register.factory(GetLockedTokens)
  @Register.factory(GetLockedPairs)
  @Register.factory(TokensRepository, from: TokensRepositoryImpl)
  @Register.factory(PairsRepository, from: PairsRepositoryImpl)
  @Register.factory(FarmingRepository, from: FarmingRepositoryImpl)
  @Register.factory(TrackerRepository, from: TrackerRepositoryImpl)
  @Register.factory(LockerRepository, from: LockerRepositoryImpl)
  void _configureTokensModuleFactories();
}
