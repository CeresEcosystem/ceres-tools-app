// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void _configureTokensModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => TokensDatasource(client: c<RestClient>()))
      ..registerFactory((c) => PairsDatasource(client: c<RestClient>()))
      ..registerFactory((c) => FarmingDatasource(client: c<RestClient>()))
      ..registerFactory((c) => TrackerDatasource(client: c<RestClient>()))
      ..registerFactory((c) => BannerDatasource(client: c<RestClient>()))
      ..registerFactory((c) => LockerDatasource(client: c<RestClient>()))
      ..registerFactory((c) => PortfolioDatasource(client: c<RestClient>()))
      ..registerFactory((c) => SwapsDatasource(client: c<RestClient>()))
      ..registerFactory(
          (c) => PairsLiquidityDatasource(client: c<RestClient>()))
      ..registerFactory((c) => PriceAlertDatasource(client: c<RestClient>()))
      ..registerFactory((c) => TBCReservesDatasource(client: c<RestClient>()))
      ..registerFactory((c) => CurrencyDatasource(client: c<RestClient>()))
      ..registerFactory((c) => KensetsuDatasource(client: c<RestClient>()))
      ..registerFactory((c) => GetTokens(repository: c<TokensRepository>()))
      ..registerFactory((c) => GetPairs(repository: c<PairsRepository>()))
      ..registerFactory((c) => GetFarming(repository: c<FarmingRepository>()))
      ..registerFactory(
          (c) => GetFarmingTVL(repository: c<FarmingRepository>()))
      ..registerFactory(
          (c) => GetTokenInfos(repository: c<FarmingRepository>()))
      ..registerFactory(
          (c) => GetDemeterFarms(repository: c<FarmingRepository>()))
      ..registerFactory(
          (c) => GetDemeterPools(repository: c<FarmingRepository>()))
      ..registerFactory((c) => GetTracker(repository: c<TrackerRepository>()))
      ..registerFactory(
          (c) => GetTrackerSupply(repository: c<TrackerRepository>()))
      ..registerFactory(
          (c) => GetTrackerBlocks(repository: c<TrackerRepository>()))
      ..registerFactory(
          (c) => GetLockedTokens(repository: c<LockerRepository>()))
      ..registerFactory(
          (c) => GetLockedPairs(repository: c<LockerRepository>()))
      ..registerFactory(
          (c) => GetPortfolioItems(repository: c<PortfolioRepository>()))
      ..registerFactory((c) => GetSwaps(repository: c<SwapsRepository>()))
      ..registerFactory(
          (c) => GetSwapsForAllTokens(repository: c<SwapsRepository>()))
      ..registerFactory(
          (c) => GetPairsLiquidity(repository: c<PairsLiquidityRepository>()))
      ..registerFactory((c) =>
          GetPairsLiquidityChart(repository: c<PairsLiquidityRepository>()))
      ..registerFactory(
          (c) => GetTBCReserves(repository: c<TBCReservesRepository>()))
      ..registerFactory(
          (c) => GetTokenHolders(repository: c<TokensRepository>()))
      ..registerFactory((c) => GetXorHolders(repository: c<TokensRepository>()))
      ..registerFactory(
          (c) => GetKensetsuBurns(repository: c<KensetsuRepository>()))
      ..registerFactory<TokensRepository>(
          (c) => TokensRepositoryImpl(datasource: c<TokensDatasource>()))
      ..registerFactory<PairsRepository>(
          (c) => PairsRepositoryImpl(datasource: c<PairsDatasource>()))
      ..registerFactory<FarmingRepository>(
          (c) => FarmingRepositoryImpl(datasource: c<FarmingDatasource>()))
      ..registerFactory<TrackerRepository>(
          (c) => TrackerRepositoryImpl(datasource: c<TrackerDatasource>()))
      ..registerFactory<LockerRepository>(
          (c) => LockerRepositoryImpl(datasource: c<LockerDatasource>()))
      ..registerFactory<PortfolioRepository>(
          (c) => PortfolioRepositoryImpl(datasource: c<PortfolioDatasource>()))
      ..registerFactory<SwapsRepository>(
          (c) => SwapsRepositoryImpl(datasource: c<SwapsDatasource>()))
      ..registerFactory<PairsLiquidityRepository>((c) =>
          PairsLiquidityRepositoryImpl(
              datasource: c<PairsLiquidityDatasource>()))
      ..registerFactory<TBCReservesRepository>((c) =>
          TBCReservesRepositoryImpl(datasource: c<TBCReservesDatasource>()))
      ..registerFactory<KensetsuRepository>(
          (c) => KensetsuRepositoryImpl(datasource: c<KensetsuDatasource>()));
  }
}
