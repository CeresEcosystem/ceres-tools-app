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
      ..registerFactory((c) => GetTokens(repository: c<TokensRepository>()))
      ..registerFactory((c) => GetPairs(repository: c<PairsRepository>()))
      ..registerFactory((c) => GetFarming(repository: c<FarmingRepository>()))
      ..registerFactory<TokensRepository>(
          (c) => TokensRepositoryImpl(datasource: c<TokensDatasource>()))
      ..registerFactory<PairsRepository>(
          (c) => PairsRepositoryImpl(datasource: c<PairsDatasource>()))
      ..registerFactory<FarmingRepository>(
          (c) => FarmingRepositoryImpl(datasource: c<FarmingDatasource>()));
  }
}
