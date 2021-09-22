import 'package:ceres_locker_app/data/api/api.dart';
import 'package:ceres_locker_app/data/datasource/farming_datasource.dart';
import 'package:ceres_locker_app/data/datasource/pairs_datasource.dart';
import 'package:ceres_locker_app/data/datasource/tokens_datasource.dart';
import 'package:ceres_locker_app/data/repository/farming_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/pairs_repository_impl.dart';
import 'package:ceres_locker_app/data/repository/tokens_repository_impl.dart';
import 'package:ceres_locker_app/domain/repository/farming_repository.dart';
import 'package:ceres_locker_app/domain/repository/pairs_repository.dart';
import 'package:ceres_locker_app/domain/repository/tokens_repository.dart';
import 'package:ceres_locker_app/domain/usecase/get_farming.dart';
import 'package:ceres_locker_app/domain/usecase/get_pairs.dart';
import 'package:ceres_locker_app/domain/usecase/get_tokens.dart';
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
    container?.registerInstance(RestClient(Dio(BaseOptions(contentType: 'application/json'))));
  }

  @Register.factory(TokensDatasource)
  @Register.factory(PairsDatasource)
  @Register.factory(FarmingDatasource)
  @Register.factory(GetTokens)
  @Register.factory(GetPairs)
  @Register.factory(GetFarming)
  @Register.factory(TokensRepository, from: TokensRepositoryImpl)
  @Register.factory(PairsRepository, from: PairsRepositoryImpl)
  @Register.factory(FarmingRepository, from: FarmingRepositoryImpl)
  void _configureTokensModuleFactories();
}
