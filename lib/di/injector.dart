import 'package:ceres_locker_app/data/api/api.dart';
import 'package:ceres_locker_app/data/datasource/banner_datasource.dart';
import 'package:ceres_locker_app/data/datasource/farming_datasource.dart';
import 'package:ceres_locker_app/data/datasource/locker_datasource.dart';
import 'package:ceres_locker_app/data/datasource/pairs_datasource.dart';
import 'package:ceres_locker_app/data/datasource/pairs_liquidity_datasource.dart';
import 'package:ceres_locker_app/data/datasource/portfolio_datasource.dart';
import 'package:ceres_locker_app/data/datasource/price_alert_datasource.dart';
import 'package:ceres_locker_app/data/datasource/swaps_datasource.dart';
import 'package:ceres_locker_app/data/datasource/tokens_datasource.dart';
import 'package:ceres_locker_app/data/datasource/tracker_datasource.dart';
import 'package:ceres_locker_app/data/repository/farming_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/locker_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/pairs_liquidity_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/pairs_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/portfolio_repository.dart';
import 'package:ceres_locker_app/data/repository/swaps_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/tokens_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/tracker_repository_impl.dart';
import 'package:ceres_locker_app/domain/repository/farming_repository.dart';
import 'package:ceres_locker_app/domain/repository/locker_repository.dart';
import 'package:ceres_locker_app/domain/repository/pairs_liquidity_repository.dart';
import 'package:ceres_locker_app/domain/repository/pairs_repository.dart';
import 'package:ceres_locker_app/domain/repository/portfolio_repository.dart';
import 'package:ceres_locker_app/domain/repository/swaps_repository.dart';
import 'package:ceres_locker_app/domain/repository/tokens_repository.dart';
import 'package:ceres_locker_app/domain/repository/tracker_repository.dart';
import 'package:ceres_locker_app/domain/usecase/get_demeter_farms.dart';
import 'package:ceres_locker_app/domain/usecase/get_demeter_pools.dart';
import 'package:ceres_locker_app/domain/usecase/get_farming.dart';
import 'package:ceres_locker_app/domain/usecase/get_farming_tvl.dart';
import 'package:ceres_locker_app/domain/usecase/get_locked_pairs.dart';
import 'package:ceres_locker_app/domain/usecase/get_locked_tokens.dart';
import 'package:ceres_locker_app/domain/usecase/get_pairs.dart';
import 'package:ceres_locker_app/domain/usecase/get_pairs_liquidity.dart';
import 'package:ceres_locker_app/domain/usecase/get_portfolio_items.dart';
import 'package:ceres_locker_app/domain/usecase/get_swaps.dart';
import 'package:ceres_locker_app/domain/usecase/get_token_infos.dart';
import 'package:ceres_locker_app/domain/usecase/get_tokens.dart';
import 'package:ceres_locker_app/domain/usecase/get_tracker.dart';
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
    _configureFeatureModule();
    _configureTokensModuleFactories();
  }

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
  @Register.factory(PortfolioDatasource)
  @Register.factory(SwapsDatasource)
  @Register.factory(PairsLiquidityDatasource)
  @Register.factory(PriceAlertDatasource)
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
  @Register.factory(GetPortfolioItems)
  @Register.factory(GetSwaps)
  @Register.factory(GetPairsLiquidity)
  @Register.factory(TokensRepository, from: TokensRepositoryImpl)
  @Register.factory(PairsRepository, from: PairsRepositoryImpl)
  @Register.factory(FarmingRepository, from: FarmingRepositoryImpl)
  @Register.factory(TrackerRepository, from: TrackerRepositoryImpl)
  @Register.factory(LockerRepository, from: LockerRepositoryImpl)
  @Register.factory(PortfolioRepository, from: PortfolioRepositoryImpl)
  @Register.factory(SwapsRepository, from: SwapsRepositoryImpl)
  @Register.factory(PairsLiquidityRepository,
      from: PairsLiquidityRepositoryImpl)
  void _configureTokensModuleFactories();
}
