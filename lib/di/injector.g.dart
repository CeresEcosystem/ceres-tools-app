// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void _configureCore() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => Connectivity())
      ..registerSingleton<NetworkInfoI>(
          (c) => NetworkInfo(connectivity: c<Connectivity>()));
  }

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
      ..registerFactory((c) => GetTokens(repository: c<TokensRepository>()))
      ..registerFactory((c) => GetPairs(repository: c<PairsRepository>()))
      ..registerFactory((c) => GetFarming(repository: c<FarmingRepository>()))
      ..registerFactory((c) => GetTracker(repository: c<TrackerRepository>()))
      ..registerFactory(
          (c) => GetLockedTokens(repository: c<LockerRepository>()))
      ..registerFactory(
          (c) => GetLockedPairs(repository: c<LockerRepository>()))
      ..registerFactory<TokensRepository>(
          (c) => TokensRepositoryImpl(datasource: c<TokensDatasource>()))
      ..registerFactory<PairsRepository>(
          (c) => PairsRepositoryImpl(datasource: c<PairsDatasource>()))
      ..registerFactory<FarmingRepository>(
          (c) => FarmingRepositoryImpl(datasource: c<FarmingDatasource>()))
      ..registerFactory<TrackerRepository>(
          (c) => TrackerRepositoryImpl(datasource: c<TrackerDatasource>()))
      ..registerFactory<LockerRepository>(
          (c) => LockerRepositoryImpl(datasource: c<LockerDatasource>()));
  }
}
